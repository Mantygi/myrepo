#!/bin/bash

LOG_FILE="/var/log/system_health.log"
THRESHOLD_CPU=80
THRESHOLD_MEM=80
THRESHOLD_DISK=80

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d. -f1)

# Get Memory usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)

# Get Disk usage
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

# Log function
log() {
    echo "$(date): $1" >> $LOG_FILE
}

log "CPU: $CPU_USAGE% | Memory: $MEM_USAGE% | Disk: $DISK_USAGE%"

# Check thresholds and send alerts
if [ "$CPU_USAGE" -gt "$THRESHOLD_CPU" ]; then
    log "ALERT: CPU usage high - $CPU_USAGE%"
fi

if [ "$MEM_USAGE" -gt "$THRESHOLD_MEM" ]; then
    log "ALERT: Memory usage high - $MEM_USAGE%"
fi

if [ "$DISK_USAGE" -gt "$THRESHOLD_DISK" ]; then
    log "ALERT: Disk usage high - $DISK_USAGE%"
fi

echo "System health check completed. Log saved."