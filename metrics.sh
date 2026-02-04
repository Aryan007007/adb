#!/data/data/com.termux/files/usr/bin/bash

# -------- Battery --------
BATTERY_CAPACITY="null"
BATTERY_TEMP_C="null"

if [ -f /sys/class/power_supply/battery/capacity ]; then
  BATTERY_CAPACITY=$(cat /sys/class/power_supply/battery/capacity)
fi

if [ -f /sys/class/power_supply/battery/temp ]; then
  # Usually in tenths of °C
  RAW_TEMP=$(cat /sys/class/power_supply/battery/temp)
  BATTERY_TEMP_C=$(awk "BEGIN { printf \"%.1f\", $RAW_TEMP/10 }")
fi

# -------- CPU Load --------
# 1, 5, 15 minute load averages
read LOAD1 LOAD5 LOAD15 _ < /proc/loadavg

# -------- Memory (MB) --------
MEM_TOTAL=$(awk '/MemTotal/ {print int($2/1024)}' /proc/meminfo)
MEM_AVAILABLE=$(awk '/MemAvailable/ {print int($2/1024)}' /proc/meminfo)
MEM_USED=$((MEM_TOTAL - MEM_AVAILABLE))

# -------- Uptime --------
UPTIME_SECONDS=$(awk '{print int($1)}' /proc/uptime)

# -------- Output --------
cat <<EOF
{
  "battery_percent": $BATTERY_CAPACITY,
  "battery_temp_c": $BATTERY_TEMP_C,
  "cpu_load": {
    "1m": $LOAD1,
    "5m": $LOAD5,
    "15m": $LOAD15
  },
  "memory_mb": {
    "total": $MEM_TOTAL,
    "used": $MEM_USED,
    "available": $MEM_AVAILABLE
  },
  "uptime_seconds": $UPTIME_SECONDS
}
EOF
