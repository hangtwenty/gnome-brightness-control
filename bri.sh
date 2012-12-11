#!/bin/bash
# gnome-brightness-control.sh: script to change laptop brightness in gnome
# author: Michael Floering

source ~/.bri # load user configuration

################
## Initialize ##
################

current_brightness_file="/tmp/gnome-brightness-control"

if [ ! -f $current_brightness_file ] ; then
    # if we don't have a file, start at default
    brightness=$default
else
    # otherwise read the value from the file
    brightness=`cat $current_brightness_file`
fi

#################
## Handle args ##
#################

### Got argument; parse.
if [ "$1" ]; then
    case "$1" in
        thaw|resume)
            # good: thaw/resume
            # (on Ubuntu scripts placed /etc/pm/sleep.d/ are 
            # run as root-user with args "thaw" or "resume",
            # upon waking from hiberation/suspend.
            brightness=$default
            ;;
        *)
            # good: + or -
            if [[ "$1" =~ ^\+$ ]] ; then
                echo "Incrementing by $interval percent"
                brightness=`expr ${brightness} + ${interval}`
            elif [[ "$1" =~ ^\-$ ]] ; then
                echo "Decrementing by $interval percent"
                brightness=`expr ${brightness} - ${interval}`
            
            # tentatively good: is either an integer or invalid.
            # interpret the value below.
            else
                brightness=$1
            fi
            ;;
    esac
elif [ ! "$1" ]; then
    ### Called without argument; 'reset' brightness to default
    echo "No percentage; setting to default instead"
    brightness=$default
fi

### Interpret $brightness - 
# bad: not +/- or an integer
if ! [[ "$brightness" =~ ^[-]?[0-9]+$ ]] ; then
    echo "Not an integer; setting to default percentage instead"
    brightness=$default
# bad: integers out of the range 0-100
elif [ "$brightness" -gt 100 ] ; then
    echo "Greater than one hundred percent; setting to 100% instead"
    brightness=100
elif [ "$brightness" -lt 0 ] ; then
    echo "Less than one hundred percent; setting to 0% instead"
    brightness=0
fi

# save setting for next time
echo "${brightness}" > $current_brightness_file

###################
## Main function ##
###################

# source that pointed me to this command: http://askubuntu.com/questions/178686/can-i-set-superuser-inside-the-launcher
gdbus call --session --dest org.gnome.SettingsDaemon --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen.SetPercentage $brightness

##########################
## Notes for the future ##
##########################

# Here is somebody's script to change brightness on plugging in the power vs. battery ... 
# http://askubuntu.com/questions/93601/change-screen-brightness-automatically-on-ac-connection-disconnection






