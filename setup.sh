#!/bin/bash
# setup.sh: set up gnome-brightness-control as command 'bri'
# author: Michael Floering

# factor out some literals
bri='bri' # the command name `bri`
_bri='.bri' # the name of the configuration file
bri_sh='bri.sh' # the original name of the shell script, in this repository.

# make sure bri.sh is executable
chmod +x $bri_sh

# copy .bri (config file) to ~/.bri
cp ./$_bri ~/$_bri

# copy bri.sh to /usr/bin/bri so that it's a command 'bri' ...
cp ./$bri_sh /usr/bin/$bri

# ... and also make a link to this script in /etc/pm/sleep.d/
# (all scripts in /etc/pm/sleep.d/ are called upon thaw/resume on waking
# from hiberation and suspend, respectively)
ln -s /usr/bin/$bri /etc/pm/sleep.d/$bri

exit 0













