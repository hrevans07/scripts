#!/usr/bin/bash

init_output=$(/usr/sbin/iptables -L TRAFFIC_ACCT -n -v -x)

/usr/sbin/iptables -Z TRAFFIC_ACCT

tcp_packets=$(/usr/bin/echo "$init_output" | /usr/bin/grep "tcp" | /usr/bin/awk '{print $1}')
udp_packets=$(/usr/bin/echo "$init_output" | /usr/bin/grep "udp" | /usr/bin/awk '{print $1}')
icmp_packets=$(/usr/bin/echo "$init_output" | /usr/bin/grep "icmp" | /usr/bin/awk '{print $1}')

tcp_size=$(/usr/bin/echo "$init_output" | /usr/bin/grep "tcp" | /usr/bin/awk '{print $2}')
udp_size=$(/usr/bin/echo "$init_output" | /usr/bin/grep "udp" | /usr/bin/awk '{print $2}')
icmp_size=$(/usr/bin/echo "$init_output" | /usr/bin/grep "icmp" | /usr/bin/awk '{print $2}')

total_packets=$(($tcp_packets + $udp_packets + $icmp_packets))
total_size=$(($tcp_size + $udp_size + $icmp_size))

data="packets,host=server01,region=us-central tcp=$tcp_packets\npackets,host=server01,region=us-central udp=$udp_packets\npackets,host=server01,region=us-central icmp=$icmp_packets\npackets,host=server01,region=us-central tcp_size=$tcp_size\npackets,host=server01,region=us-central udp_size=$udp_size\npackets,host=server01,region=us-central icmp_size=$icmp_size"

#echo "$data"
pkts="\ntotal packets:"
echo "Data written to influx @ $(/usr/bin/date) --- total packets: $total_packets --- total packet size in bytes: $total_size" >> /home/honeynet/scripts/simple_series_queries

curl -i -XPOST 'http://localhost:8086/write?db=simple_series&u=writer&p=writerpassword123' --data-binary @- <<EOF
`echo -e $data`
EOF
