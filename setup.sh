#!/bin/bash
# setup.sh: set up gnome-brightness-control as command 'bri'
# author: Michael Floering

# make sure bri.sh is executable
chmod +x bri.sh

# copy it to /usr/bin/ so that it's a command 'bri'
gksudo "cp ./bri.sh /usr/bin/bri"






