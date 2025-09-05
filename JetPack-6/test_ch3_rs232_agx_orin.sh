#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

gpioset --mode=signal `gpiofind "SERIAL_CH3.RS485/RS232#"`=0 &
PID_RS422_232=$!
gpioset --mode=signal `gpiofind "SERIAL_CH3.TERM"`=0 &
PID_TERM=$!

sudo gtkterm -p /dev/ttyTHS2 -s 115200

kill $PID_RS422_232
kill $PID_TERM

