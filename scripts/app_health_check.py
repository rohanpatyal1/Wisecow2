#!/usr/bin/env python3
"""Simple application health checker.
Usage: python3 app_health_check.py http://localhost:4499
"""
import sys
import requests

def check(url, timeout=5):
    try:
        r = requests.get(url, timeout=timeout)
        if 200 <= r.status_code < 400:
            print(f"UP: {url} returned {r.status_code}")
            return 0
        else:
            print(f"DOWN: {url} returned {r.status_code}")
            return 2
    except Exception as e:
        print(f"DOWN: {url} error: {e}")
        return 3

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: app_health_check.py <url>")
        sys.exit(1)
    sys.exit(check(sys.argv[1]))
