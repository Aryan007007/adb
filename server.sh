#!/data/data/com.termux/files/usr/bin/bash

PORT=9100
METRICS_SCRIPT="$HOME/monitor/adb/metrics.sh"

while true; do
  {
    echo -e "HTTP/1.1 200 OK\r"
    echo -e "Content-Type: application/json\r"
    echo -e "Cache-Control: no-cache\r"
    echo -e "\r"
    $METRICS_SCRIPT
  } | busybox nc -l -p $PORT -q 1
done
