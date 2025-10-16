#!/bin/bash

# System Health Monitoring Script
# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

LOG_FILE="/var/log/system_health.log"

log_alert() {
    echo "$(date): ALERT - $1" | tee -a $LOG_FILE
}

check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        log_alert "CPU usage is ${CPU_USAGE}% (threshold: ${CPU_THRESHOLD}%)"
    fi
}

check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
    if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
        log_alert "Memory usage is ${MEM_USAGE}% (threshold: ${MEM_THRESHOLD}%)"
    fi
}

check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
    if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
        log_alert "Disk usage is ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
    fi
}

check_processes() {
    PROCESS_COUNT=$(ps aux | wc -l)
    if [ $PROCESS_COUNT -gt 200 ]; then
        log_alert "High number of running processes: $PROCESS_COUNT"
    fi
}

main() {
    echo "Starting system health check..."
    check_cpu
    check_memory
    check_disk
    check_processes
    echo "System health check completed."
}

main
