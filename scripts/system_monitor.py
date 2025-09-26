#!/usr/bin/env python3
"""
System Health Monitoring Script
Usage: python3 system_monitor.py
"""

import psutil
import time
import datetime
import logging

# thresholds
CPU_THRESHOLD = 80.0      # percent
MEM_THRESHOLD = 80.0      # percent
DISK_THRESHOLD = 85.0     # percent

LOGFILE = "system_monitor.log"
SAMPLE_INTERVAL = 30      # seconds

logging.basicConfig(filename=LOGFILE,
                    level=logging.INFO,
                    format="%(asctime)s - %(levelname)s - %(message)s")

def check():
    cpu = psutil.cpu_percent(interval=1)
    mem = psutil.virtual_memory().percent
    disk = psutil.disk_usage("/").percent

    msgs = []
    if cpu > CPU_THRESHOLD:
        msgs.append(f"CPU usage high: {cpu}%")
    if mem > MEM_THRESHOLD:
        msgs.append(f"Memory usage high: {mem}%")
    if disk > DISK_THRESHOLD:
        msgs.append(f"Disk usage high: {disk}%")

    # Example process check: ensure a named process is running (optional)
    # process_found = any('wisecow' in p.name().lower() for p in psutil.process_iter())
    # if not process_found:
    #     msgs.append("Wisecow process not found")

    if msgs:
        for m in msgs:
            logging.warning(m)
            print("ALERT:", m)
    else:
        msg = f"OK - CPU:{cpu}%, MEM:{mem}%, DISK:{disk}%"
        logging.info(msg)
        print(msg)

if _name_ == "_main_":
    try:
        while True:
            check()
            time.sleep(SAMPLE_INTERVAL)
    except KeyboardInterrupt:
        print("Stopped by user")
