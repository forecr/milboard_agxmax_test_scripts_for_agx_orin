#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

RS422_232_NUM=300
RS422_232=gpio300
RS422_232_VAL=1
TERM_NUM=301
TERM=gpio301
TERM_VAL=1
SERIAL_PORT=ttyTHS0

echo $RS422_232_NUM > /sys/class/gpio/export
echo out > /sys/class/gpio/$RS422_232/direction
echo $TERM_NUM > /sys/class/gpio/export
echo out > /sys/class/gpio/$TERM/direction

echo $RS422_232_VAL > /sys/class/gpio/$RS422_232/value
echo $TERM_VAL > /sys/class/gpio/$TERM/value

sudo gtkterm -p /dev/$SERIAL_PORT -s 115200

echo $RS422_232_NUM > /sys/class/gpio/unexport
echo $TERM_NUM > /sys/class/gpio/unexport

