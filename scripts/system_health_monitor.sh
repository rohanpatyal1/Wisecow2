#!/usr/bin/env bash
# Simple system health monitor
CPU_THRESH=80
MEM_THRESH=80
DISK_THRESH=80

logfile="/tmp/system_health.log"

echo "" > "$logfile"

check_cpu() {
  cpu=$(top -bn1 | grep "%Cpu(s)" | awk -F'id,' '{ split($1, vs, ","); gsub("%","",vs[1]); print 100 - vs[1] }')
  cpu_int=${cpu%.*}
  if [ "$cpu_int" -ge "$CPU_THRESH" ]; then
    echo "$(date) CPU high: ${cpu}%" >> "$logfile"
  fi
}

check_mem() {
  mem=$(free | awk '/Mem/ {printf("%.0f", $3/$2 * 100.0)}')
  if [ "$mem" -ge "$MEM_THRESH" ]; then
    echo "$(date) MEM high: ${mem}%" >> "$logfile"
  fi
}

check_disk() {
  disk=$(df --output=pcent / | tail -1 | tr -d ' %')
  if [ "$disk" -ge "$DISK_THRESH" ]; then
    echo "$(date) DISK high: ${disk}%" >> "$logfile"
  fi
}

check_proc() {
  # example: ensure nc is running (adjust as needed)
  if ! pgrep -f nc >/dev/null; then
    echo "$(date) WARNING: nc not running" >> "$logfile"
  fi
}

check_all() {
  check_cpu
  check_mem
  check_disk
  check_proc
}

if [ "$1" == "once" ]; then
  check_all
  exit 0
fi

while true; do
  check_all
  sleep 30
done
