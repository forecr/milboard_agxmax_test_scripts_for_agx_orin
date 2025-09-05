#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

gpioset --mode=signal `gpiofind "SERIAL_CH0.RS485/RS232#"`=1 &
PID_RS422_232=$!
gpioset --mode=signal `gpiofind "SERIAL_CH0.TERM"`=1 &
PID_TERM=$!

sudo gtkterm -p /dev/ttyTHS1 -s 115200

kill $PID_RS422_232
kill $PID_TERM

