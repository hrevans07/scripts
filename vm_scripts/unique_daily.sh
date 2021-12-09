#!/usr/bin/bash

cd /home/honeytrap/raw_captures
merged=$(mergecap -a $(ls -t /home/honeytrap/raw_captures | tail -n +2) -w ~/out.pcap)
