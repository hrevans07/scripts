#!/usr/bin/bash

# Scipt for starting honeytraps canary listner in background

rm -f nohup.out
/usr/bin/nohup /usr/local/sbin/canary --config /home/honeytrap/honeytrap/config.toml --data /data/ > /dev/null &
