#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROC_THRESHOLD=1000

# Log file
LOG_FILE="/tmp/system_health.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# CPU Usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
    log_message "ALERT: CPU usage is ${cpu_usage}% (threshold: ${CPU_THRESHOLD}%)"
else
    log_message "CPU usage is ${cpu_usage}% (OK)"
fi

# Memory Usage
mem_total=$(free | grep Mem | awk '{print $2}')
mem_used=$(free | grep Mem | awk '{print $3}')
mem_percent=$((100 * mem_used / mem_total))
if [ "$mem_percent" -gt "$MEM_THRESHOLD" ]; then
    log_message "ALERT: Memory usage is ${mem_percent}% (threshold: ${MEM_THRESHOLD}%)"
else
    log_message "Memory usage is ${mem_percent}% (OK)"
fi

# Disk Usage
disk_percent=$(df -h / | tail -n 1 | awk '{print $5}' | cut -d% -f1)
if [ "$disk_percent" -gt "$DISK_THRESHOLD" ]; then
    log_message "ALERT: Disk usage is ${disk_percent}% (threshold: ${DISK_THRESHOLD}%)"
else
    log_message "Disk usage is ${disk_percent}% (OK)"
fi

# Running Processes
proc_count=$(ps -e | wc -l)
if [ "$proc_count" -gt "$PROC_THRESHOLD" ]; then
    log_message "ALERT: Running processes: ${proc_count} (threshold: ${PROC_THRESHOLD})"
else
    log_message "Running processes: ${proc_count} (OK)"
fi

# Summary
log_message "System health check complete. See $LOG_FILE for details."
