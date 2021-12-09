#!/usr/bin/bash

# Get second newest pcap -> newest full capture
cap=$(/usr/bin/ls -Art /home/honeytrap/raw_captures | /usr/bin/tail -n 2 | /usr/bin/head -n 1)

# Use tshark to count number of unique ip addr in pcap
unique=$(/usr/bin/tshark -r "/home/honeytrap/raw_captures/$cap" -q -z conv,ip | /usr/bin/awk '{print $1}' | /usr/bin/grep -v '^128.10' | /usr/bin/sort | /usr/bin/uniq | /usr/bin/grep '^[1-9]' | /usr/bin/wc -l)

# Use capinfo to get total number of packets captured
total=$(/usr/bin/capinfos "/home/honeytrap/raw_captures/$cap" | grep "Number of packets =" | awk -F'= ' '{print $2}')

# Use tcpdump to count number of inbound udp/tcp connections
udp=$(/usr/sbin/tcpdump -nr "/home/honeytrap/raw_captures/$cap" 'udp' | /usr/bin/cut -f2-5 -d ' ' | /usr/bin/grep -v '^IP 128.105' | /usr/bin/sort -u | /usr/bin/wc -l)
tcp=$(/usr/sbin/tcpdump -nr "/home/honeytrap/raw_captures/$cap" 'tcp[tcpflags] & (tcp-syn|tcp-ack) = (tcp-syn|tcp-ack)' | /usr/bin/wc -l)

# Create http request payload
data="honeytrap,host=vm-01,region=us-central unique_ip=$unique\nhoneytrap,host=vm-01,region=us-central total_packets=$total\nhoneytrap,host=vm-01,region=us-central tcp_inbound=$tcp\nhoneytrap,host=vm-01,region=us-central udp_inbound=$udp"

# Curl to the influx instance
curl -i -XPOST 'http://192.168.122.1:8086/write?db=simple_series&u=writer&p=writerpassword123' --data-binary @- <<EOF
`echo -e $data`
EOF

# Record pcap used for debugging purproses
# Every entry in this file should be unique
/usr/bin/echo $cap >> /home/honeytrap/scripts/pcaps_used.log

# Because this VM has very small amount of storage, get rid of pcap once it has been processed
/usr/bin/rm "/home/honeytrap/raw_captures/$cap"
