# Raspberry Pi Base Operating System
RaspberryPi base OS setup and configuration.

You need to have _expect_ installed on your system for these scripts to run.

## What is in here?
* Installs basic tools (vim, net-tools, snapd)
* Disables apparmor
* Updates the upgrades to the latest release of this Debian OS
* Reboots the Pi to apply all changes

## HOWTO
* Download a raspberry pi image and install it onto an SD card (8GB+ size). Make sure SSH is enabled in this image. HOWTOs for that are available via Google.
* Connect your raspberry to the internal network and boot it up using the SD card you just created.
* Determine the IP of the raspberry within the internal network.
* Execute the script:
```
./install.sh <IPofPI>
```
* Wait for installation to complete.

Check the scripts in the _custom_ directory. They are executed in the numbered order.
