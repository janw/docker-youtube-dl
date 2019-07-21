#!/bin/bash
set -uo pipefail
IFS=$'\n\t'

if [ "${LOG:-}" = "yes" ]; then
    youtube-dl --config-location /config/config.txt --batch-file /config/batch.txt $@ 2>&1 | tee /downloads/download.log
else
    youtube-dl --config-location /config/config.txt --batch-file /config/batch.txt $@
fi

([ $? -eq 0 ] && touch /tmp/healthy) || rm /tmp/healthy
