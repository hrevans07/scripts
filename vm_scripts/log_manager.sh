#!/usr/bin/bash

# Script for creating daily logs of honeytraps output

# Create the daily file and change name
/usr/bin/mv /data/honeytrap/honeytrap.log /data/honeytrap/logs/honeytrap-$(/usr/bin/date  --date="yesterday" +"%d-%m-%y").log

# Chmod so that logs are readable
/usr/bin/chmod 444 /data/honeytrap/logs/*
