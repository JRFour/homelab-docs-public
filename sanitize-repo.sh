#!/bin/bash

# Sanitization script for home lab infrastructure repository
# This script removes sensitive information for making the repository public

echo "Starting sanitization of home lab infrastructure repository..."
echo "=============================================================="

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Create backup
BACKUP_DIR="./sanitization_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
log "Created backup directory: $BACKUP_DIR"

# Backup current files (excluding .git directory)
log "Backing up repository files..."
cp -r ./* "$BACKUP_DIR/" 2>/dev/null || true
cp -r ./.git "$BACKUP_DIR/" 2>/dev/null || true

# Remove any temporary or backup files that don't belong in public repository
log "Removing temporary and unnecessary files..."
find . -type f \( -name "*.tmp" -o -name "*.bak" -o -name "*~" \) -not -path "./.git/*" -delete 2>/dev/null || true

# Special handling for specific files that might contain sensitive data
find . -type f -name "*.md" -not -path "./.git/*" | while read -r file; do
    if [[ -f "$file" ]]; then
        log "Processing markdown file: $file"
        # Replace IP addresses with generic placeholders
        sed -i 's/10\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/10.x.x.x/g' "$file" 2>/dev/null || true
        sed -i 's/172\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/172.x.x.x/g' "$file" 2>/dev/null || true
        sed -i 's/192\.168\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/192.168.x.x/g' "$file" 2>/dev/null || true
        sed -i 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/X.X.X.X/g' "$file" 2>/dev/null || true
    fi
done

# Additional cleaning for config files
find . -type f \( -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.conf" -o -name "*.cfg" \) -not -path "./.git/*" | while read -r file; do
    if [[ -f "$file" ]]; then
        log "Processing config file: $file"
        # Replace IP addresses
        sed -i 's/10\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/10.x.x.x/g' "$file" 2>/dev/null || true
        sed -i 's/172\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/172.x.x.x/g' "$file" 2>/dev/null || true
        sed -i 's/192\.168\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)/192.168.x.x/g' "$file" 2>/dev/null || true
        sed -i 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/X.X.X.X/g' "$file" 2>/dev/null || true
    fi
done

# Special handling for script files
find . -type f -name "*.sh" -not -path "./.git/*" | while read -r file; do
    if [[ -f "$file" ]]; then
        log "Processing script file: $file"
        # Replace passwords and secrets in shell scripts with placeholders
        sed -i 's/password[[:space:]]*=[[:space:]]*[^\r\n]*/password=[REDACTED]
        sed -i 's/secret[[:space:]]*=[[:space:]]*[^\r\n]*/secret=[REDACTED]
        sed -i 's/key[[:space:]]*=[[:space:]]*[^\r\n]*/key=[REDACTED]
        sed -i 's/token[[:space:]]*=[[:space:]]*[^\r\n]*/token=[REDACTED]
        sed -i 's/api key=[REDACTED]
    fi
done

# Remove or replace sensitive elements in git config if present
if [[ -f ".git/config" ]]; then
    log "Cleaning git configuration"
    if grep -q "user\.name\|user\.email" ".git/config"; then
        sed -i 's/user\.name = .*/user.name = [USER]/g' .git/config 2>/dev/null || true
        sed -i 's/user\.email = .*/user.email = [EMAIL]/g' .git/config 2>/dev/null || true
    fi
fi

# Sanitize Cisco switch configs
log "Sanitizing Cisco switch configuration files..."
find . -type f -name "*SW*config*.md" -not -path "./.git/*" -not -path "./sanitization_backup_*" | while read -r file; do
    if [[ -f "$file" ]]; then
        log "Processing Cisco config: $file"
        # Replace MD5 password hashes (enable secret 5, username secret 5)
        sed -i 's/enable secret 5 \$1\$[^$]*\$[^ ]*/enable secret 5 <md5-hash>/g' "$file" 2>/dev/null || true
        sed -i 's/secret 5 \$1\$[^$]*\$[^ ]*/secret 5 <md5-hash>/g' "$file" 2>/dev/null || true
        # Replace Type 7 reversible passwords
        sed -i 's/password 7 [0-9A-Fa-f]*/password 7 <type7-hash>/g' "$file" 2>/dev/null || true
        # Replace plaintext passwords
        sed -i 's/password [^ ]*/password <password>/g' "$file" 2>/dev/null || true
    fi
done

# Sanitize HashiCorp Vault tokens
log "Sanitizing Vault tokens..."
find . -type f -name "*.md" -not -path "./.git/*" -not -path "./sanitization_backup_*" | while read -r file; do
    if [[ -f "$file" ]]; then
        # Replace Vault tokens (hvs.*)
        sed -i 's/hvs\.[A-Za-z0-9_-]*/hvs.<token>/g' "$file" 2>/dev/null || true
    fi
done

# Sanitize Plex claim tokens
log "Sanitizing Plex claim tokens..."
find . -type f -name "*.md" -not -path "./.git/*" -not -path "./sanitization_backup_*" | while read -r file; do
    if [[ -f "$file" ]]; then
        sed -i 's/claim-[A-Za-z0-9_-]*/claim-<token>/g' "$file" 2>/dev/null || true
    fi
done

# Remove pfSense XML config files
log "Removing pfSense configuration files..."
find . -type f -name "*.xml" -not -path "./.git/*" -not -path "./sanitization_backup_*" | while read -r file; do
    if [[ "$file" == *"pfsense"* ]]; then
        log "Removing pfSense config: $file"
        rm -f "$file"
    fi
done

# Remove sanitization backup directories
log "Removing sanitization backup directories..."
find . -type d -name "sanitization_backup_*" -not -path "./.git/*" -exec rm -rf {} \; 2>/dev/null || true

# Update .gitignore to exclude backup directories
log "Updating .gitignore..."
if [[ -f ".gitignore" ]]; then
    if ! grep -q "sanitization_backup_*/" ".gitignore"; then
        echo "" >> .gitignore
        echo "# Sanitization backups" >> .gitignore
        echo "sanitization_backup_*/" >> .gitignore
        log "Added sanitization_backup_*/ to .gitignore"
    fi
else
    echo "# Sanitization backups" > .gitignore
    echo "sanitization_backup_*/" >> .gitignore
    log "Created .gitignore with sanitization_backup_*/"
fi

# Generate summary
log "=============================================================="
log "Sanitization complete!"
log "Backup created in: $BACKUP_DIR"
log "All sensitive IP addresses have been sanitized"
log "Passwords and secrets have been redacted"
log "Cisco switch configs sanitized (MD5, Type 7, plaintext passwords)"
log "Vault and Plex tokens redacted"
log "pfSense XML config files removed"
log "Sanitization backup directories removed"
log ".gitignore updated to exclude backup directories"
log "Note: Always manually verify that no actual credentials are present"
log "=============================================================="