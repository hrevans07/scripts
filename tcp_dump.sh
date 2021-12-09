#!/usr/bin/bash

s="time started:"
echo "$s $(/usr/bin/date)" >> /home/honeynet/scripts/tcp_dump_check

/usr/sbin/tcpdump -G 84600 -W 1 -w /home/honeynet/raw_captures/capture-%Y-%m-%d -i enp24s0f1 -n not arp and port not 22 and not stp
