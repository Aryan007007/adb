#!/data/data/com.termux/files/usr/bin/bash

# ---------------- Battery ----------------
BATTERY_JSON=$(termux-battery-status 2>/dev/null)

BATTERY_PERCENT=$(echo "$BATTERY_JSON" | awk -F'[:,]' '/"percentage"/ {print $2}')
BATTERY_TEMP_RAW=$(echo "$BATTERY_JSON" | awk -F'[:,]' '/"temperature"/ {print $2}')

if [ -n "$BATTERY_TEMP_RAW" ]; then
  BATTERY_TEMP_C=$(awk "BEGIN { printf \"%.1f\", $BATTERY_TEMP_RAW }")
else
  BATTERY_TEMP_C="null"
fi

[ -z "$BATTERY_PERCENT" ] && BATTERY_PERCENT="null"

# ---------------- CPU (snapshot) ----------------
# Android does not expose loadavg to apps anymore
CPU_SNAPSHOT=$(top -bn1 | head -n 5 | tr '\n' ' ')

# ---------------- Memory ----------------
# Still allowed on Android 14
MEM_TOTAL=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
MEM_AVAILABLE=$(awk '/MemAvailable/ {print int($2/1024)}' /proc/meminfo)
MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))

# ---------------- Uptime ----------------
# Use command, not /proc
UPTIME_SECONDS=$(uptime | awk '{print int($3*3600 + $5*60)}')

# ---------------- Output ----------------
cat <<EOF
{
  "battery": {
    "percent": $BATTERY_PERCENT,
    "temperature_c": $BATTERY_TEMP_C
  },
  "cpu": {
    "snapshot": "$CPU_SNAPSHOT"
  },
  "memory_mb": {
    "total": $MEM_TOTAL,
    "used": $MEM_USED,
    "available": $MEM_AVAILABLE
  },
  "uptime_seconds": $UPTIME_SECONDS
}
EOF

