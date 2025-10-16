#!/bin/bash

# Application Health Checker Script
# Usage: ./app_health_checker.sh <url>

URL=$1
if [ -z "$URL" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

check_app() {
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL)
    if [ $HTTP_CODE -eq 200 ]; then
        echo "Application is UP (HTTP $HTTP_CODE)"
        return 0
    else
        echo "Application is DOWN (HTTP $HTTP_CODE)"
        return 1
    fi
}

main() {
    echo "Checking application health for $URL..."
    if check_app; then
        echo "Health check passed."
    else
        echo "Health check failed."
        exit 1
    fi
}

main
