## gnome-brightness-control

This is a simple script for manipulating brightness in the GNOME desktop environment. It may be useful if you are using GNOME and you cannot, out of the box, manipulate your laptop's brightness freely, easily, or consistently.

This script is a thin wrapper around a `gdbus` command: `gdbus call --session --dest org.gnome.SettingsDaemon --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen.SetPercentage <some_percentage>`. I was alerted to this command by [Alex L. on AskUbuntu](http://askubuntu.com/questions/178686/can-i-set-superuser-inside-the-launcher).

For example, I am using Ubuntu 12.04 on a Samsung laptop (NP300V4A-A03US). Out of the box, `Fn + F2` is bound to decrement brightness and `Fn + F3` to increment it. Both the settings menu's slider for brightness and these keyboard shortcuts have a problem with my laptop: they will not lower the brightness below ~80%, and the brightness setting is lost after a little while. I am not sure what underlying command or program is responsible, but the `gdbus` command (above) works even though these built-in functionalities do not.

## Usage

### Return to last brightness or a pre-set "default" brightness


    bri

You can configure this behavior (see *Configuration* below).

I recommend calling this on startup. In Ubuntu, go to `System > Preferences > Startup Applications` and add this command.

### Increment/decrement brightness

    bri + # increment
    bri - # decrement

I recommend binding these two commands to two adjacent keys. For example, I map `Ctrl + F2` to `bri -` and `Ctrl + F3` to `bri +`.

### Set to a brightness between 0 and 100%

    bri 42

Sets to 42% brightness. When I am working in bash and I want to change brightness, I tend to use this method.

## Setup

This is a bash script. It may work in other shells, as I have tried to make it portable, but I have not tested this.

### Install

    cd <path/to/this/repo>
    sudo bash setup.sh

Jot down the `interval` setting it recommends.

#### Do I *need* to run it as root?

Yes. Read the code in `setup.sh` if you want to make sure it doesn't do anything bad.

### Disable auto-dim

If you are using Ubuntu, I would recommend that you go into `System Settings > Brightness and Lock` and **uncheck** *Dim screen to save power*. If your environment is like mine (and you've gotten this far, so I assume it is), returning from dim will set computer to 100% brightness, which is very annoying and doesn't play well with this script.

### Configure it (necessary for proper functioning)

You should now have a configuration file `~/.bri`. Edit it to change `bri`'s settings.

There is one setting you will certainly want to change - `bri_interval`. This is the number of percentage points to increment/decrement by when using `bri +` orr `bri -`. The optimal interval differs with your hardware, but the setup script should have recommended a good setting for `bri_interval` on your system. Set `bri_interval` to the value it recommended, then try it out. You may want to fiddle with this, adding or subtracting one point -- or if you *really* like to fiddle, try changing the setting of `bri_minimum`.

The two other settings, `bri_persist` and `bri_default` are related. If `bri_persist` is `true`, executing `bri` without an argument will set the brightness to the last brightness `bri` knew about. If you keep this value set to `true`, and call `bri` as a startup script, you will have the effect of consistent brightness. Otherwise, some part of your Linux environment may set the brightness back to 100 (etc.) upon booting or waking the computer (this is my experience).

Alternatively, if you set `bri_persist` is `false`, executing `bri` without an argument will always set the brightness to a consistent value - the percentage specified by `bri_default`.

## Planned work

### Change brightness on plugging in your laptop

A good script for doing just this can be found in the answer [here](http://askubuntu.com/questions/93601/change-screen-brightness-automatically-on-ac-connection-disconnection), on AskUbuntu. Should be straightforward to implement in our script, but haven't gotten around to it yet!

### Make it more portable (if anyone uses it)

There is an **Issues** section on this GitHub page. If you try to install this script and experience issues, please open a ticket. I'll see if I can find solutions to any problems that are reported.

## Gratuitous technical note

If you look in the script you'll notice I store "current brightness" in a temporary file, rather than using the system's internal measure of brightness. This is because the `GetPercentage` function in gdbus -- `gdbus call --session --dest org.gnome.SettingsDaemon --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Screen.GetPercentage ` -- does work as expected, at least in my environment. For some reason it has the side-effect of *setting* the brightness to 100, before returning the current brightness.

Let me know if you know an alternative way to fetch this value (that is hardware-independent).

