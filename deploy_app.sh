#!/bin/bash

# --- DevOps Automated Deployment Script ---
# Simulates provisioning a web server environment on our compute tier.

echo "🌐 Starting automated application provisioning..."

# Target configuration variables
SERVER_DIR="./mock_server"
INDEX_FILE="$SERVER_DIR/index.html"

# 1. Create a mock server directory simulating a system path like /var/www/html
if [ ! -d "$SERVER_DIR" ]; then
    mkdir -p "$SERVER_DIR"
    echo "📁 Created server deployment directory: $SERVER_DIR"
fi

# 2. Automatically generate a landing page with deployment details
cat <<EOF > "$INDEX_FILE"
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Automated Deployment</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; color: #333; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #0066cc; }
        .status { display: inline-block; background: #28a745; color: white; padding: 5px 10px; border-radius: 4px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Deployment Successful!</h1>
        <p><strong>Environment:</strong> Development</p>
        <p><strong>Status:</strong> <span class="status">ONLINE</span></p>
        <p>This infrastructure tier was provisioned and validated via automated scripts.</p>
    </div>
</body>
</html>
EOF

echo "✍️  Generated application deployment artifact: $INDEX_FILE"
echo "✅ Application provisioning complete!"
