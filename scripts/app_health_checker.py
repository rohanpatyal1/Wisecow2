#!/usr/bin/env python3
"""
Application Health Checker
Usage: python3 app_health_checker.py --url http://localhost:3000/health --interval 30
"""
import requests
import time
import argparse
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def check(url, timeout=5):
    try:
        r = requests.get(url, timeout=timeout)
        if 200 <= r.status_code < 300:
            logging.info(f"UP - {url} returned {r.status_code}")
            return True
        else:
            logging.warning(f"DOWN - {url} returned {r.status_code}")
            return False
    except Exception as e:
        logging.error(f"DOWN - {url} error: {e}")
        return False

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", required=True)
    parser.add_argument("--interval", type=int, default=30)
    args = parser.parse_args()
    url = args.url

    while True:
        ok = check(url)
        # optionally send alerts (email/slack) here
        time.sleep(args.interval)

if _name_ == "_main_":
    main()
