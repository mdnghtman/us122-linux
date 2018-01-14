#!/bin/bash

echo "Installing needed packages"
echo

sudo apt-get install fxload alsa-base alsa-firmware-loaders alsa-tools alsa-tools-gui alsa-utils alsamixergui alien

echo "Downloading alsa-firmware and install"
echo

wget ftp://ftp.alsa-project.org/pub/firmware/alsa-firmware-1.0.29.tar.bz2
tar -xvjf alsa-firmware-1.0.29.tar.bz2
cd alsa-firmware-1.0.29
./configure --prefix=/usr && sudo make install

echo "Reconfiguring alsa-base"
echo

sudo dpkg-reconfigure alsa-base
cd usx2yloader

echo "Read output of lsusb and extract Bus and Device number of Tascam US-122"
echo

test=$(lsusb | grep "Tascam")
echo "$test"
echo

IFS=' '
array=( $test )
Bus=${array[1]}
Device=${array[3]::-1}

echo "Bus = $Bus"
echo "Device = $Device"
echo

echo "/dev/bus/usb/$Bus/$Device"
echo

echo "Issue fxload"
echo

sudo fxload -s ./tascam_loader.ihx -I /usr/share/alsa/firmware/usx2yloader/us122fw.ihx -D /dev/bus/usb/$Bus/$Device

sudo ln -s /usr/share/alsa/firmware/usx2yloader /lib/firmware/usx2yloader

echo "Driver was installed."
