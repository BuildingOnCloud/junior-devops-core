#!/bin/bash

# --- DevOps Automation Scaffolding Script ---
# This script automates the creation of the modular Terraform directory structure.

echo "🚀 Starting infrastructure directory scaffolding..."

# Create the network module directory path if it doesn't exist
mkdir -p modules/network

# Array of target network module files to generate
MODULE_FILES=(
    "modules/network/main.tf"
    "modules/network/variables.tf"
    "modules/network/outputs.tf"
)

# Loop through and initialize each module file safely
for file in "${MODULE_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        touch "$file"
        echo "📂 Created module file: $file"
    else
        echo "⚠️  File already exists: $file (Skipping)"
    fi
done

# Initialize the root layout configuration file
if [ ! -f "main.tf" ]; then
    touch "main.tf"
    echo "📂 Created root configuration file: main.tf"
else
    echo "⚠️  File already exists: main.tf (Skipping)"
fi

echo "✅ Scaffolding automation complete!"
