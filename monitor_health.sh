#!/bin/bash

# --- DevOps Automation: Phase 3 Health & Monitoring Script ---
echo "📊 Initializing system monitoring checks..."

LOG_FILE="./server_monitor.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "==========================================" >> "$LOG_FILE"
echo "🕒 Check executed at: $TIMESTAMP" >> "$LOG_FILE"

# 1. Simulate a network endpoint availability check (pinging our mock app)
# In production, this would use a tool like 'curl -I http://YOUR_SERVER_IP'
if [ -f "./mock_server/index.html" ]; then
    echo "✅ App Endpoint Status: 200 OK (Application Artifact Present)" >> "$LOG_FILE"
    echo "🟢 Web service check passed."
else
    echo "❌ App Endpoint Status: 404 NOT FOUND (Artifact Missing!)" >> "$LOG_FILE"
    echo "🔴 Web service check failed!"
fi

# 2. Capture hardware metrics (Disk Utilization Check)
echo "💾 Gathering storage tier resource metrics..."
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
echo "📊 Root Disk Space Utilization: $DISK_USAGE" >> "$LOG_FILE"

echo "💾 Storage check completed. Current usage: $DISK_USAGE"
echo "📝 Metrics successfully appended to $LOG_FILE"
