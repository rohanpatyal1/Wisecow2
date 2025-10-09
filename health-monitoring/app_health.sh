#!/bin/bash

# Application URL
URL="https://wisecow.local"

# Log file
LOG_FILE="/tmp/app_health.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Check application status
http_status=$(curl --insecure -s -o /dev/null -w "%{http_code}" "$URL" 2>/dev/null)
if [ "$http_status" -eq 200 ]; then
    log_message "Application is healthy: $URL (HTTP $http_status)"
    exit 0
else
    log_message "Application is down: $URL (HTTP $http_status or unreachable)"
    exit 1
fi
