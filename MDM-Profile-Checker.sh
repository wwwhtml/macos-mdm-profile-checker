#!/bin/sh
#Script name: MDM-Profile-Checker.sh
#Author: Daniel Arauz - DanArauz@gmail.com
#Date: 2019-01-21 (MLK Day)
#Description: Works way faster if remote computer has the controller computer's SSH Public key already.
#This script checks for MDM Profiles in remote MacOS computers:
#Support files:
#        ip-list.txt (add the computer IPs to check)
#        MDM-Profile-Checker.sh
#        file2.sh
#Steps:
#        The script MDM-Profile-Checker.sh runs and grabs IPs from ip-list.txt.
#        then checks if the IP responds to ping.
#                If computer doesn't pings back:
#                        Records locally that the host is not online.
#                        Then the scripts grabs the following IP from the ip-list.txt and the process starts again.
#                If it pings back:
#                        Via SCP sends the script file2.sh to the remote computer.
#                        Then via SSH  runs file2.sh, it checks for Profiles.
#        The results are logged locally.
#
# How to run it: sh MDM-Profile-Checker.sh ip-list.txt file2.sh
# As today, 2019-01-27, in this script the remote admin account is 'radmin', replaced it with the one in your remote computer's to check. 
# I intend to make a variable for that user, but not today. :)
# +-------------------------------------------------------------------------------------------------------------------------------------+
clear
echo "MDM Profile Checker"
echo "-------------------"
echo "This script will connect to remote MacOS hosts and check if MDM profiles are installed or not."
echo " "
echo "Files required for this task:"
echo "    ip-list.txt"
echo "    MDM-Profile-Checker.sh"
echo "    file2.sh"
echo " "
echo "Results at: $(pwd)/results.log"
echo ""
read -p "Press [ENTER] to continue, or CTRL+C to quit."
clear
echo ""
echo "MDM Profile Checker in progress..."
echo ""
for ip in `cat $1`
do        
	echo "+-------------------------------------------------------------------------------------+"
        echo "---> CHECKING REMOTE HOST $ip FOR AVAILABILITY..."
	touch pingResults.log
	ping -c 3 "$ip" -W 3 > pingResults.log
	hostUpYesorNot=$(cat pingResults.log | grep 100 | grep loss)
	hostDOWN="3 packets transmitted, 0 packets received, 100.0% packet loss"
	if [[ "$hostUpYesorNot" == "$hostDOWN" ]] ; then
		#echo "---> PINGING HOST: $ip"
		isDown="OFFLINE" 
		echo "$ip\t$isDown" >> results.log
                echo "$ip" >> OFFLINE-IPs-ONLY.log
		echo "$ip $isDown" 
		rm -r pingResults.log
		#echo "Results at $(pwd) file: results.log"
	else
		echo "We're good to go!"
		echo "---> UPLOADING FILE TO HOST: $ip"
		a="scp -o StrictHostKeyChecking=no file2.sh radmin@"
		b=":$2"
		$a$ip$b
		echo "---> CHECKING FOR PROFILES..."
		c="ssh -t radmin@"
		d=" sh $2"
		$c$ip$d
		echo "---> COLLECTING RESULTS..."
		echo " Done!"
		ssh -t radmin@$ip "cat profiles-check-results.log" >> results.log
	fi
done
echo "+-------------------------------------------------------------------------------------+"
echo "Find results at: $(pwd)/results.log"
echo ""
echo ""
