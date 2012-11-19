#!/bin/bash
# gnome-brightness-control.sh: increment/decrement brightness in gnome
# author: Michael Floering

source $(dirname $0)/config.cfg

################
## Initialize ##
################

# TODO: ythe thing that stores a value for brightness and does increments/decrements of it. That's the core functionality.
# PUT THAT IN ANOTHER FILE, THAT PASSES ARGUMENTS TO THIS ONE.

if ! $1; then
    brightness_percentage=$default
else
    if $1 -gt 100; then
        brightness_percentage=100
    elif $1 -lt 0; then
        brightness_percentage=0
    elif $1 IS NOT A NUMBER; then
        brightness_percentage=$default
    else
        brightness_percentage=$1
    fi
fi

# XXX:
# There is a function that should  GET brightness:
# gdbus call --session --dest org.gnome.SettingsDaemon --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen.GetPercentage
# but for me it always SETS to 100. So currently we do not have a way to GET brightness.

###################
## Main function ##
###################

# source that pointed me to this command: http://askubuntu.com/questions/178686/can-i-set-superuser-inside-the-launcher
gdbus call --session --dest org.gnome.SettingsDaemon --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen.SetPercentage $brightness_percentage


##########################
## Possible functions ? ##
##########################

# Here is somebody's script to change brightness on plugging in the power vs. battery ... 
# http://askubuntu.com/questions/93601/change-screen-brightness-automatically-on-ac-connection-disconnection




