#!/usr/bin/bash

# Scipt for starting tcpdump in background

rm -f nohup.out
nohup /usr/sbin/tcpdump -i enp7s0 -G 900 -w /home/honeytrap/raw_captures/capture-%Y-%m-%d-%H-%M-%S -n not arp and not stp &

# Write start time to log file
echo $(date) >> /home/honeytrap/scripts/tcpdump.log
