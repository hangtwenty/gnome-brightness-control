#!/bin/bash
# setup.sh: set up gnome-brightness-control as command 'bri'
# author: Michael Floering

# factor out some literals
bri='bri'
_bri='.bri'
bri_sh='bri.sh'

# make sure bri.sh is executable
chmod +x $bri_sh

# copy .bri (config file) to ~/.bri
cp ./$_bri ~/$_bri

# copy bri.sh to /usr/bin/ so that it's a command 'bri',
cp ./$bri_sh /usr/bin/$bri
# and also copy it to /etc/pm/sleep.d/ so it is called on 'thaw' and 'resume'
# (from hiberation and suspend, respectively)
cp ./$bri_sh /etc/pm/sleep.d/$bri

exit 0














