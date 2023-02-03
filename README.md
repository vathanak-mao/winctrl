# winctrl

This script is intended to use with Touchegg gestures. For example, when a user does 4-finger swipe up, execute this script to minimize the current active window; and when the user make 4-finger swipe down, execute this script to unminimize the last minimized window.

<img src="https://github.com/vathanak-mao/winctrl/blob/main/.github/demo.gif"/>

## How-to
Supposed the Touchegg has been installed and configured, open the Touchegg's configuration file, ~/.config/touchegg/touchegg.conf, then add the following lines in the <application/> tag.
	
	<gesture type="SWIPE" fingers="4" direction="DOWN">
		<action type="RUN_COMMAND">
			<repeat>false</repeat>
			<command>winctrl.sh -v true</command>
			<on>begin</on>
		 </action>
	</gesture>
	<gesture type="SWIPE" fingers="4" direction="UP">
		 <action type="RUN_COMMAND">
			<repeat>false</repeat>
			<command>winctrl.sh -v false</command>
			<on>begin</on>
		 </action>
	</gesture>
	


