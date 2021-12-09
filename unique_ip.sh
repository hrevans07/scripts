#!/usr/bin/bash

sudo tcpdump -i enp24s0f1 -G 900 -w /home/honeynet/raw_captures/capture-%Y-%m-%d-%H-%M-%S -n not arp and port not 22 and not stp
