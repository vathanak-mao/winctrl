#!/bin/bash

# Redirect the output of echo command to a log file
#exec > >(tee -i /run/lock/winctrl.log)
#exec 2>&1


if [[ $1 = "-v" ]]; then
	if [[ $2 = false ]]; then
		#echo ">> Checking if there is an active window..."

		active_winid=$(printf 0x%x $(xdotool getactivewindow)) # convert from dec to hex
		#echo ">> Found an active/opening window <$active_winid>"
		
		if [[ $active_winid -gt 0x0 ]]; then
			xdotool windowminimize $active_winid
			#echo ">> Minimized the window <$active_winid>"
		else
			#echo ">> No active window found!"
		fi
	else 
		#echo ">> Checking if there is a minimized window..."
		
		str_ids=$(xprop -root | grep "^_NET_CLIENT_LIST_STACKING" | cut -d'#' -f2)
		IFS=', ' read -r -a ids <<< "$str_ids"
		#echo "${ids[@]}"

		for (( idx=${#ids[@]}-1 ; idx>=0 ; idx-- )) ; do
			#echo ">> Looping: ids[$idx]=$((ids[idx]))"

			# If the window is hidden/minimized
			if xwininfo -all -id $((ids[idx])) |grep "Hidden"; then
				#echo ">> Found a minimized window <$((ids[idx]))>"
				
				wmctrl -ia $((ids[idx]))
				#echo ">> Unminimized the window <$((ids[idx]))>"
				
				exit 0
			fi
		done
		
		#echo ">> No minimized window found!"
	fi
else
	#echo "Please specify an option, for example 'appctrl -v true', to raise and focus on the app window, and 'appctrl -v false' to minimize the app window."
fi



