#!/bin/bash

    ####################################################################################################################
    #                                                                                                                  #
    #    This script retrieves the system's boot time using sysctl, gets the current Unix time using date,             #
    #    calculates the elapsed time since boot time, and then calculates the system uptime in days, hours,            #
    #    minutes, and seconds. Finally, it replaces commas in the output with newlines and removes any extra spaces.   #
    #                                                                                                                  #
    ####################################################################################################################

# Get the boot time of the system and extract the fourth field
boottime=$(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',')

# Get the current Unix time
unixtime=$(date +%s)

# Calculate the elapsed time since boot time
timeAgo=$((unixtime - boottime))

# Calculate the system uptime in days, hours, minutes, and seconds
up_time=$(awk -v time=$timeAgo 'BEGIN {
    seconds = time % 60;
    minutes = int(time / 60 % 60);
    hours = int(time / 3600 % 24);
    days = int(time / 86400);
    printf("%d days, %02d hours, %02d minutes, %02d seconds", days, hours, minutes, seconds);
    exit
}')

# Replace commas in the output with newlines and remove extra spaces
echo -e "${up_time//,/\n}" | awk '{$1=$1}1'
