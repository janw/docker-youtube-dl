#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

PIDFILE="/tmp/ydl.pid"

if [ -e "${PIDFILE}" ] && (ps -opid | grep "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
  echo "Already running."
  exit 0
fi

youtube-dl \
    --config-location /config/config.txt \
    --batch-file /config/batch.txt $@ 2>&1 | \
    tee /downloads/download.log &

echo $! > "$PIDFILE"
chmod 644 "$PIDFILE"
