#!/usr/bin/env python3
import requests
from datetime import datetime

URL = "https://vinay-tilada.bestinthebizz.in/"

def check_app_health(url):
    try:
        response = requests.get(url, timeout=5)
        status_code = response.status_code
        if 200 <= status_code < 300:
            print(f"[{datetime.now()}]  Application is UP. Status Code: {status_code}")
        else:
            print(f"[{datetime.now()}]  Application DOWN! Status Code: {status_code}")
    except requests.exceptions.RequestException as e:
        print(f"[{datetime.now()}]  Application DOWN! Error: {e}")

if __name__ == "__main__":
    check_app_health(URL)
