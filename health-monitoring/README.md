# Problem Statement 2: System and Application Health Monitoring

## Overview
Implements two scripts for monitoring system and application health as part of the Wisecow project.

## Artifacts
- `system_health.sh`: Monitors system metrics (CPU >80%, memory >80%, disk >80%, processes >1000).
- `app_health.sh`: Checks Wisecow app’s HTTPS endpoint[](https://wisecow.local) for HTTP 200.

## Setup & Verification
1. **System Health**:
   ```bash
   ~/wisecow/health-monitoring/system_health.sh
   cat /tmp/system_health.log

Output: System metrics with alerts if thresholds exceeded (e.g., CPU 0%, Memory 27%, Disk 2%, Processes 102).

2. **Application Health**:
```bash
~/wisecow/health-monitoring/app_health.sh
cat /tmp/app_health.log

Output: Reports if Wisecow app is up (HTTP 200) or down (e.g., HTTP 200 confirmed).
