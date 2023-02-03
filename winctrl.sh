#!/bin/bash

ids_filename="/run/lock/winctrl.ids"
tmp_ids_filename="/run/lock/winctrl.ids.tmp"

if [[ $1 = "-v" ]]; then
	if [[ $2 = false ]]; then
		echo ">> Start minimizing the app window."

		active_winid=$(printf 0x%x $(xdotool getactivewindow)) # convert from dec to hex
		echo ">> active_winid=$active_winid"
		
		if [[ $active_winid -gt 0x0 ]]; then
			xdotool windowminimize $active_winid	# minimize the window
			
			# remove previously saved window id
			# this might happen when the user manually open the window and use this script to hide it again
			sed -i "/$active_winid/d" $ids_filename

			# append a new window id
			echo $active_winid >> $ids_filename	# append the window id in cache
		fi 	
	else 
		echo ">> Start raising the app window."
		
		while true
		do
			# If the cache file exists and not empty 
			if [[ -f "${ids_filename}" && -s "${ids_filename}" ]]; then
			
				# get the last minimized window id
				lastminimized_winid=$(tail -n 1 $ids_filename)
				echo ">> lastminimized_winid=$lastminimized_winid"
				
				# remove the last minimized window id from the cache
				head -n -1 $ids_filename > $tmp_ids_filename
				mv $tmp_ids_filename $ids_filename
				
				# if it's being minimized (the user hasn't manually opened it)
				if xwininfo -all -id $lastminimized_winid | grep "Hidden"; then
	  				# activate the window
					xdotool windowactivate $lastminimized_winid
					
					echo ">> Raised the app window <$lastminimized_winid>."
					break
	  			else 
	  				echo ">> The app window <$lastminimized_winid> has manually opened by the user (not using this script)."
	  				continue
	  			fi
				
			else # the cache file does not exist or empty (no minimized window id saved)
				echo ">> The cache file $ids_filename does not exist or is empty so can't raise the app window <$lastminimized_winid>."
			
				# If there is minimized app, which is manually done by a user, then????
				# else
				break
			fi
		done
	fi
else
	echo "Please specify an option, for example 'appctrl -v true', to raise and focus on the app window, and 'appctrl -v false' to minimize the app window."
	
fi




