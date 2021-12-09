#!/usr/bin/bash

# This is a script that is in charge of deleting files that have been read already by the friendly-tagger
# This sript is ran by cron every minute, so the interval will need to be greater than that
# Note that this script identifies files to be delted by checking file access/modify times, so any files
# that are manually edited (not by the tagger) will be deleted by this script
# Also note that this script will only look in the /home/honey/test_trace directory

shopt -s nullglob

files=(/home/honeynet/test_trace/*)

for ((i=0; i<${#files[@]}; i++)); do
	acc=$(stat "${files[$i]}" | grep -i 'access' | grep -vi 'uid' | awk '{print $3}')
	mdify=$(stat "${files[$i]}" | grep -i 'modify' | awk '{print $3}')
	if [[ "$acc" != "$mdify" ]]; then
		rm -f ${files[$i]}
	fi
done
