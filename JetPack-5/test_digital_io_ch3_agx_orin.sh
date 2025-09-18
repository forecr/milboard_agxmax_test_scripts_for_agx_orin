#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

read -p "Input or Output (i/o): " IO_CHOICE
case $IO_CHOICE in
	[Ii]* )
		echo 311 > /sys/class/gpio/export
		echo in > /sys/class/gpio/gpio311/direction
		watch -n 0.1 cat /sys/class/gpio/gpio311/value
		echo 311 > /sys/class/gpio/unexport
		;;
	[Oo]* )
		echo 311 > /sys/class/gpio/export
		echo out > /sys/class/gpio/gpio311/direction
		echo "DIGITAL_IO_CH0 OFF"
		echo 0 > /sys/class/gpio/gpio311/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH0 ON"
		echo 1 > /sys/class/gpio/gpio311/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH0 OFF"
		echo 0 > /sys/class/gpio/gpio311/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH0 ON"
		echo 1 > /sys/class/gpio/gpio311/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH0 OFF"
		echo 0 > /sys/class/gpio/gpio311/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH0 ON"
		echo 1 > /sys/class/gpio/gpio311/value
		echo 311 > /sys/class/gpio/unexport
		;;
	* )
		echo "Wrong choice"
		;;
esac

