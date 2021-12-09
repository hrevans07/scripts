#!/bin/bash

# Simple script for some info about the interface "enp24s0f1"
# Displays packets received per second by defualt but 
# accepts -a -s flag to display both received and sent packts
# and just sent packets

Help() {
	echo "Usage: ./packet_count.sh [FLAG]"
	echo ""
	echo "  -a     Display received and sent packets."
	echo "  -s     Display sent packets."
	echo "  -r     Display received packets. (Default)"
	echo "  -t     Display packets received in specified amount of seconds. Requires an argument of seconds."
	echo ""
	exit
}


time="1"     # one second
int="enp24s0f1"   # network interface
val=3

while getopts asrt:h options; do
	case $options in
		a) val=1;;
		s) val=2;;
		r) val=3;;
		t) time=${OPTARG}
			val=4;;
		h) Help
	esac
done

while true
do
	if (("$val"==1)); then
		old_tx="`cat /sys/class/net/$int/statistics/tx_packets`" # sent packets
		old_rx="`cat /sys/class/net/$int/statistics/rx_packets`" # recv packets
		sleep $time
		new_tx="`cat /sys/class/net/$int/statistics/tx_packets`" # sent packets
		new_rx="`cat /sys/class/net/$int/statistics/rx_packets`" # recv packets
		diff_tx="`expr $new_tx - $old_tx`"
		diff_rx="`expr $new_rx - $old_rx`"
		echo "sent: $diff_tx pkts - received $diff_rx pkts on interface $int"
	fi
	if (("$val"==2)); then
		old_tx="`cat /sys/class/net/$int/statistics/tx_packets`" # sent packets
		sleep $time
		new_tx="`cat /sys/class/net/$int/statistics/tx_packets`" # sent packets
		diff_tx="`expr $new_tx - $old_tx`"
		echo "sent $diff_tx pkts on interface $int"
	fi
	if (("$val"==3)); then
		old_rx="`cat /sys/class/net/$int/statistics/rx_packets`" # recv packets
		sleep $time
		new_rx="`cat /sys/class/net/$int/statistics/rx_packets`" # recv packets
		diff_rx="`expr $new_rx - $old_rx`"
		echo "received $diff_rx pkts on interface $int"
	fi
	if (("$val"==4)); then
		echo "counting packets that are received on interface $int in next $time seconds:"
		old_rx="`cat /sys/class/net/$int/statistics/rx_packets`"
		sleep $time
		new_rx="`cat /sys/class/net/$int/statistics/rx_packets`" # recv packets
		diff_rx="`expr $new_rx - $old_rx`"
		echo "received $diff_rx pkts on interface $int in last $time seconds"
		exit
	fi
done
