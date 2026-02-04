#!/data/data/com.termux/files/usr/bin/bash

# -------- Battery --------
BATTERY_PERCENT="null"
BATTERY_TEMP_C="null"

if [ -f /sys/class/power_supply/battery/capacity ]; then
  BATTERY_PERCENT=$(cat /sys/class/power_supply/battery/capacity)
fi

if [ -f /sys/class/power_supply/battery/temp ]; then
  RAW_TEMP=$(cat /sys/class/power_supply/battery/temp)
  BATTERY_TEMP_C=$(awk "BEGIN { printf \"%.1f\", $RAW_TEMP/10 }")
fi

# -------- CPU (snapshot, not loadavg) --------
CPU_USAGE=$(top -bn1 | grep -m1 "CPU")

# -------- Memory (MB) --------
MEM_TOTAL=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
MEM_AVAILABLE=$(awk '/MemAvailable/ {print int($2/1024)}' /proc/meminfo)
MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))

# -------- Uptime (via command, not /proc) --------
UPTIME_SECONDS=$(uptime | awk -F'( |,|:)+' '{print ($3*3600)+($4*60)}')

# -------- Output --------
cat <<EOF
{
  "battery_percent": $BATTERY_PERCENT,
  "battery_temp_c": $BATTERY_TEMP_C,
  "cpu_snapshot": "$CPU_USAGE",
  "memory_mb": {
    "total": $MEM_TOTAL,
    "used": $MEM_USED,
    "available": $MEM_AVAILABLE
  },
  "uptime_seconds": $UPTIME_SECONDS
}
EOF
