#!/bin/bash
# gnome-brightness-control.sh: script to change laptop brightness in gnome
# author: Michael Floering

. ~/.bri # load user configuration

################
## Initialize ##
################

current_brightness_file="/tmp/gnome-brightness-control"

if [ ! -f $current_brightness_file ] ; then
    # if we don't have a file, start at default
    brightness=$bri_default
else
    # otherwise read the value from the file
    brightness=`cat $current_brightness_file`
fi

#################
## Handle args ##
#################

### Test that there is an argument, or set to a no-op argument if there is none.
if [ ! "$1" ]; then
    # if no argument, set $bri_arg to this no-op string.
    bri_arg="not_a_number"
    # Explanation for this:
    #   `case` doesn't seem to have a good way to catch an empty string.
    #   this catches an empty string / absense of argument and rewrites it
    #   as a "no-op" string / argument. the reason for this is that we need
    #   to catch non-number arguments before we get to the number-comparison
    #   that happens after the case statement.
else
    bri_arg="$1"
fi

### Interpret argument
case "$bri_arg" in
    *[!0-9]* ) # is NOT a string of digits
        # so this nested case statement processes all non-digit arguments.
        case "$bri_arg" in
            + ) # increment
                echo "Incrementing by $bri_interval percent"
                brightness=`expr ${brightness} + ${bri_interval}`
                ;;
            - ) # decrement
                echo "Decrementing by $bri_interval percent"
                brightness=`expr ${brightness} - ${bri_interval}`
                ;;
            thaw|resume|* ) # explicit is better than implicit :)
                # *
                #   no (known) argument.
                # thaw|resume
                #   bri is being run on returning from hibernation/suspend.
                #   (on Ubuntu scripts placed /etc/pm/sleep.d/ are 
                #   run as root-user with args "thaw" or "resume",
                #   upon waking from hiberation/suspend.
                echo "Bare invocation. (No arg, bad arg, or arg was thaw/resume.)"
                if [ ! $bri_persist ]; then
                    echo "Setting to default brightness."
                    brightness=$bri_default
                else
                    echo "Setting to last brightness."
                # brightness already == $current_brightness_file from earlier.
                fi
                ;;
        esac
        ;;
    *)  # alright, then it must be a string of digits
        # (this also catches an empty string, but that was weeded out above)
        brightness=$1
        ;;
esac

# double-check brightness to avoid errors;
# reset integers out of the range 0-100 to 0/100 of that range
if [[ "$brightness" =~ ^[-]?[0-9]+$ ]] ; then
    if [ "$brightness" -gt 100 ] ; then
        echo "Greater than one hundred percent; setting to 100% instead"
        brightness=100
    elif [ "$brightness" -lt $bri_minimum ] ; then
        echo "Less than minimum; setting to minimum instead ($bri_minimum)"
        brightness=$bri_minimum
    fi
else
    echo "For some reason, brightness is $brightness and is not a number."
    echo "Exiting with status 1"
    exit 1
fi

# save setting for next time
echo "${brightness}" > $current_brightness_file

########################
## Set the brightness ##
########################

# source that pointed me to this command: http://askubuntu.com/questions/178686/can-i-set-superuser-inside-the-launcher
gdbus call --session --dest org.gnome.SettingsDaemon --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen.SetPercentage $brightness

exit 0
