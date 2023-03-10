#!/bin/bash

# Redirect the output of echo command to a log file
#exec > >(tee -i /run/lock/winctrl.log)
#exec 2>&1

echo ">> First param: $1, Second param: $2"

if [[ $1 = "-v" ]]; then
	## If hide window
	if [[ $2 = false ]]; then
		#echo ">> Checking if there is an active window..."

		active_winid=$(xdotool getactivewindow)
		#echo ">> Found an active/opening window <$active_winid>"
		
		## If there is one opening window
		if [[ $active_winid -gt 0 ]]; then
			xdotool windowminimize $active_winid
			#echo ">> Minimized the window <$active_winid>"
		else
			echo ">> No active window found!"
		fi
	elif [[ $2 = true ]]; then
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
	else
		echo "Please specify an option, for example '-v true', to raise and focus on the app window, or '-v false' to minimize the app window."
	fi
elif [[ $1 == "--toggle-desktop" ]]; then 

	if [[ $(wmctrl -m | grep "showing the desktop") == "Window manager's \"showing the desktop\" mode: ON" ]]; then
		wmctrl -k off
	elif [[ $(wmctrl -m | grep "showing the desktop") == "Window manager's \"showing the desktop\" mode: OFF" ]]; then
		wmctrl -k on
	else
		echo ">> ERROR: the output from the 'wmctrl -m' command has changed."
	fi

else
	echo "Please specify an option, for example '-v true', to raise and focus on the app window, or '-v false' to minimize the app window."
fi



