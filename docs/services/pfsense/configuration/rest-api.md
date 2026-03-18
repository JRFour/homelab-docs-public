# REST API Configuration

## Overview

The pfSense firewall includes a REST API package that enables programmatic management of the firewall configuration. This API is used for automated management of static DHCP mappings and other network configuration elements.

## Package Installation

For pfSense CE 2.8.0, install the REST API package using:
```bash
pkg-static add https://github.com/jaredhendrickson13/pfsense-api/releases/latest/download/pfSense-2.8.0-pkg-RESTAPI.pkg
```

After any pfSense update, reinstall the package using the same command for the updated version.

## Authentication

Configure API access through the webConfigurator:
1. Go to **System → REST API**
2. Enable the API and set authentication to **API Key** (recommended)
3. Assign appropriate privileges to your API user (e.g., `System: REST API`, `Services: DHCP`)

## Key API Endpoints

### Static DHCP Mappings
- **`GET /api/v2/sercices/dhcp_server/static_mapping`**: List all static DHCP mappings for a specified interface (e.g., `lan`, `opt1`)
- **`POST /api/v2/sercices/dhcp_server/static_mapping`**: Create a new static IP reservation for a device using its MAC address
- **`PUT /api/v2/sercices/dhcp_server/static_mapping/{id}`**: Update an existing static mapping (e.g., change IP, hostname, or description)
- **`DELETE /api/v2/sercices/dhcp_server/static_mapping/{id}`**: Remove a static IP reservation

## Required Parameters for Static Mapping

When creating or updating a static mapping, the following key fields are used:
- `parent_id`: The network interface (e.g., `lan`, `opt1`)
- `mac`: The MAC address of the client device
- `ipaddr`: The static IP address to assign
- `hostname`: Optional hostname for the device
- `descr`: Optional description for the reservation

## Example Usage

Example `curl` command to create a static mapping:
```bash
curl -X POST https://pfsense.hogwarts.home/api/v2/dhcpd/static_mapping \
  -H "Authorization: Bearer 7f96ed3a71cac381fa18ab6fdbc08f1c" \
  -H "Content-Type: application/json" \
  -d '{
    "parent_id": "opt1",
    "mac": "00:11:22:33:44:55",
    "ipaddr": "10.10.20.100",
    "cid": "string",
    "hostname": "printer-01",
    "domain": "hogwarts.home",
    "domainsearchlist": [
      "string"
    ],
    "defaultleasetime": 7200,
    "maxleasetime": 86400,
    "gateway": "string",
    "dnsserver": [
      "string"
    ],
    "winsserver": [
      "string"
    ],
    "ntpserver": [
      "string"
    ],
    "arp_table_static_entry": true,
    "descr": "Office Printer"
  }'
```

## Security Considerations

- The API supports HATEOAS (Hypermedia as the Engine of Application State), allowing you to discover available endpoints dynamically
- For detailed documentation, access the interactive Swagger UI at `https://your-pfsense.local/api/v2/schema/openapi`
- Always **back up your configuration** before making changes via API
- The API is **not officially supported by Netgate** but is maintained by the community

## Access Control

API access should be restricted to authorized users only:
- Use strong API keys with limited privileges
- Implement network-level access controls
- Regularly rotate API keys
- Monitor API access logs
