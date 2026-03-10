#!/bin/bash

# Validate YAML files in the repository
# This script will check all YAML files for syntax errors

echo "Starting YAML validation..."

# Find all YAML files
find . -name "*.yml" -o -name "*.yaml" | while read -r file; do
    echo "Checking $file..."
    
    # Use yamllint if available
    if command -v yamllint &> /dev/null; then
        yamllint "$file"
        if [ $? -eq 0 ]; then
            echo "✓ $file is valid"
        else
            echo "✗ $file has validation errors"
        fi
    else
        echo "⚠ yamllint not installed, using basic validation"
        # Basic YAML validation using python
        python -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "✓ $file is valid"
        else
            echo "✗ $file has validation errors"
        fi
    fi
done

echo "YAML validation complete."