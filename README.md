# winctrl

Purpose:
	This script should be used with Touchegg to minimize or unminimize an app window when swipe up or down, respectively.

Usage (with Touchegg):
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
	


