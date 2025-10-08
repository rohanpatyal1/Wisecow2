#!/usr/bin/env python3
import psutil
import logging

# Thresholds
CPU_THRESHOLD = 80
MEM_THRESHOLD = 80
DISK_THRESHOLD = 90

# Logging setup
logging.basicConfig(
    filename="system_health.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

def check_cpu():
    cpu = psutil.cpu_percent(interval=1)
    if cpu > CPU_THRESHOLD:
        msg = f"High CPU Usage! {cpu}%"
        print(msg)
        logging.warning(msg)

def check_memory():
    mem = psutil.virtual_memory().percent
    if mem > MEM_THRESHOLD:
        msg = f"High Memory Usage! {mem}%"
        print(msg)
        logging.warning(msg)

def check_disk():
    disk = psutil.disk_usage('/').percent
    if disk > DISK_THRESHOLD:
        msg = f"High Disk Usage! {disk}%"
        print(msg)
        logging.warning(msg)

def check_processes():
    proc_count = len(psutil.pids())
    msg = f"Running Processes: {proc_count}"
    print(msg)
    logging.info(msg)

if __name__ == "__main__":
    print("System Health Check")
    logging.info("System Health Check Started")
    check_cpu()
    check_memory()
    check_disk()
    check_processes()
    logging.info("System Health Check Completed")

