#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PFSENSE_HOST="${PFSENSE_HOST:-pfsense.hogwarts.home}"
API_TOKEN="${PFSENSE_API_TOKEN:-}"
DOMAIN="${PFSENSE_DOMAIN:-hogwarts.home}"
DRY_RUN="${DRY_RUN:-0}"
DEBUG="${DEBUG:-0}"
INSECURE="${INSECURE:-1}"

CURL_OPTS="-s"
[[ "$INSECURE" == "1" ]] && CURL_OPTS="$CURL_OPTS -k"

get_interface_for_ip() {
    local ip=$1
    local third_octet=$(echo "$ip" | cut -d. -f3)
    
    case "$third_octet" in
        20) echo "opt1" ;;
        30) echo "opt2" ;;
        40) echo "opt3" ;;
        50) echo "opt4" ;;
        10) echo "opt6" ;;
        60) echo "opt7" ;;
        70) echo "opt8" ;;
        80) echo "opt9" ;;
        90) echo "opt10" ;;
        *) echo "opt1" ;;
    esac
}

if [[ -z "$API_TOKEN" ]]; then
    echo "ERROR: PFSENSE_API_TOKEN environment variable not set" >&2
    exit 1
fi

if [[ "$DRY_RUN" == "1" ]]; then
    echo "=== DRY RUN MODE - No changes will be made ==="
fi

TERRAFORM_OUTPUT=$(terraform output -json 2>/dev/null)

if [[ -z "$TERRAFORM_OUTPUT" ]]; then
    echo "ERROR: No terraform output found. Run 'terraform apply' first." >&2
    exit 1
fi

CONTAINER_INFO=$(echo "$TERRAFORM_OUTPUT" | jq '.container_info.value' 2>/dev/null) || {
    echo "ERROR: Could not parse container_info from terraform output" >&2
    exit 1
}

if [[ "$CONTAINER_INFO" == "null" ]]; then
    echo "ERROR: container_info output not found. Ensure Terraform output includes container_info." >&2
    exit 1
fi

echo "$CONTAINER_INFO" | jq -r --arg host "$PFSENSE_HOST" --arg token "$API_TOKEN" --arg domain "$DOMAIN" '
to_entries[] | 
select(.value.ip_address != "") | 
select(.value.mac_address != "") |
select(.value.ip_address != "null") |
select(.value.mac_address != "null") |
select(.value.vlan_id != null) |
{
    hostname: .value.hostname,
    mac: .value.mac_address,
    ip: (.value.ip_address | split("/")[0]),
    vlan_id: .value.vlan_id
} | 
tojson
' | while read -r json; do
    if [[ -n "$json" ]]; then
        hostname=$(echo "$json" | jq -r '.hostname') || { echo "ERROR: Failed to parse hostname"; continue; }
        ipaddr=$(echo "$json" | jq -r '.ip') || { echo "ERROR: Failed to parse IP for $hostname"; continue; }
        mac=$(echo "$json" | jq -r '.mac') || { echo "ERROR: Failed to parse MAC for $hostname"; continue; }
        
        if [[ "$ipaddr" == "null" || -z "$ipaddr" ]]; then
            echo "SKIPPED: No IP address for $hostname"
            continue
        fi
        
        interface=$(get_interface_for_ip "$ipaddr")
        
        echo "Processing $hostname ($ipaddr) on $interface..."
        
        if [[ "$DEBUG" == "1" ]]; then
            echo "  DEBUG: JSON payload: $json"
        fi
        
        EXISTING=$(curl $CURL_OPTS -X GET "https://$PFSENSE_HOST/api/v2/services/dhcp_server/static_mappings?parent_id=$interface" \
            -H "x-api-key: $API_TOKEN" \
            -H "Content-Type: application/json" 2>/dev/null) || true
        
        # Check if a mapping already exists for this IP or MAC (use .id instead of .uuid)
        EXISTING_MAPPING=$(echo "$EXISTING" | jq --arg ip "$ipaddr" --arg mac "$mac" \
            '.data[] | select(.ipaddr == $ip or .mac == $mac) | .id' 2>/dev/null) || true
        
        if [[ -n "$EXISTING_MAPPING" ]]; then
            # Extract existing values (use .id instead of .uuid)
            EXISTING_IP=$(echo "$EXISTING" | jq -r --arg id "$EXISTING_MAPPING" '.data[] | select(.id == ($id | tonumber)) | .ipaddr')
            EXISTING_MAC=$(echo "$EXISTING" | jq -r --arg id "$EXISTING_MAPPING" '.data[] | select(.id == ($id | tonumber)) | .mac')
            EXISTING_HOSTNAME=$(echo "$EXISTING" | jq -r --arg id "$EXISTING_MAPPING" '.data[] | select(.id == ($id | tonumber)) | .hostname')
            
            # Compare with new values
            if [[ "$ipaddr" == "$EXISTING_IP" && "$mac" == "$EXISTING_MAC" ]]; then
                echo "  SKIPPED: Static mapping already exists for $ipaddr (identical)"
                continue
            else
                # Values differ - prompt user to overwrite
                echo "  UPDATE NEEDED: Existing mapping differs from new value"
                echo "    Existing: IP=$EXISTING_IP MAC=$EXISTING_MAC Hostname=$EXISTING_HOSTNAME"
                echo "    New:      IP=$ipaddr MAC=$mac Hostname=$hostname"
                
                if [[ "${FORCE_UPDATE:-0}" == "1" ]]; then
                    echo "  FORCE UPDATE mode - updating..."
                else
                    read -r -p "  Overwrite mapping? [y/N] " response
                    case "$response" in
                        [yY])
                            echo "  Proceeding with update..."
                            ;;
                        *)
                            echo "  SKIPPED: User declined update"
                            continue
                            ;;
                    esac
                fi
                
                # Prepare update payload with ID (pfSense uses .id not .uuid)
                mapping_id=$(echo "$EXISTING_MAPPING" | tr -d '"')
                PAYLOAD=$(echo "$json" | jq --arg iface "$interface" --arg domain "$DOMAIN" --arg id "$mapping_id" '
                    . + {
                        parent_id: $iface,
                        ipaddr: .ip,
                        cid: "",
                        domain: $domain,
                        domainsearchlist: [],
                        defaultleasetime: null,
                        maxleasetime: null,
                        gateway: "",
                        dnsserver: null,
                        winsserver: null,
                        ntpserver: null,
                        arp_table_static_entry: false,
                        descr: "Auto-provisioned via Terraform",
                        id: ($id | tonumber)
                    } | del(.vlan_id, .ip)
                ')
                
                # Perform the PATCH update (use id= instead of uuid=)
                if [[ "$DRY_RUN" == "1" ]]; then
                    echo "  [DRY RUN] Would update mapping $mapping_id with: $PAYLOAD"
                    continue
                fi
                
                RESPONSE_FILE=$(mktemp)
                HTTP_CODE=$(curl $CURL_OPTS -w "%{http_code}" -X PATCH "https://$PFSENSE_HOST/api/v2/services/dhcp_server/static_mapping?id=$mapping_id" \
                    -H "x-api-key: $API_TOKEN" \
                    -H "Content-Type: application/json" \
                    -d "$PAYLOAD" -o "$RESPONSE_FILE")
                
                if [[ "$DEBUG" == "1" ]]; then
                    echo "  DEBUG: HTTP $HTTP_CODE, Response: $(cat "$RESPONSE_FILE")"
                fi
                
                if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
                    if grep -q '"status".*"ok"' "$RESPONSE_FILE" 2>/dev/null; then
                        APPLY_RESP=$(curl $CURL_OPTS -X POST "https://$PFSENSE_HOST/api/v2/services/dhcp_server/apply" \
                            -H "x-api-key: $API_TOKEN" 2>/dev/null) || true
                        echo "  SUCCESS: Updated mapping $mapping_id"
                    else
                        echo "  FAILED: API returned error: $(cat "$RESPONSE_FILE")"
                    fi
                else
                    echo "  FAILED: HTTP $HTTP_CODE - $(cat "$RESPONSE_FILE")"
                fi
                rm -f "$RESPONSE_FILE"
                continue
            fi
        fi
        
        PAYLOAD=$(echo "$json" | jq --arg iface "$interface" --arg domain "$DOMAIN" '
            . + {
                parent_id: $iface,
                ipaddr: .ip,
                cid: "",
                domain: $domain,
                domainsearchlist: [],
                defaultleasetime: null,
                maxleasetime: null,
                gateway: "",
                dnsserver: null,
                winsserver: null,
                ntpserver: null,
                arp_table_static_entry: false,
                descr: "Auto-provisioned via Terraform"
            } | del(.vlan_id, .ip)
        ')
        
        if [[ "$DRY_RUN" == "1" ]]; then
            echo "  [DRY RUN] Would add: $PAYLOAD"
            continue
        fi
        
        RESPONSE_FILE=$(mktemp)
        HTTP_CODE=$(curl $CURL_OPTS -w "%{http_code}" -X POST "https://$PFSENSE_HOST/api/v2/services/dhcp_server/static_mapping" \
            -H "x-api-key: $API_TOKEN" \
            -H "Content-Type: application/json" \
            -d "$PAYLOAD" -o "$RESPONSE_FILE")
        
        if [[ "$DEBUG" == "1" ]]; then
            echo "  DEBUG: HTTP $HTTP_CODE, Response: $(cat "$RESPONSE_FILE")"
        fi
        
        if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
            if grep -q '"status".*"ok"' "$RESPONSE_FILE" 2>/dev/null; then
                APPLY_RESP=$(curl $CURL_OPTS -X POST "https://$PFSENSE_HOST/api/v2/services/dhcp_server/apply" \
                    -H "x-api-key: $API_TOKEN" 2>/dev/null) || true
                echo "  SUCCESS"
            else
                echo "  FAILED: API returned error: $(cat "$RESPONSE_FILE")"
            fi
        else
            echo "  FAILED: HTTP $HTTP_CODE - $(cat "$RESPONSE_FILE")"
        fi
        rm -f "$RESPONSE_FILE"
    fi
done