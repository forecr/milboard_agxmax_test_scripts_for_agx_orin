#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	exit 1
fi

sleep_time=0.3

read -p "Input or Output (i/o): " IO_CHOICE
case $IO_CHOICE in
	[Ii]* )
		echo 313 > /sys/class/gpio/export
		echo in > /sys/class/gpio/gpio313/direction
		watch -n 0.1 cat /sys/class/gpio/gpio313/value
		echo 313 > /sys/class/gpio/unexport
		;;
	[Oo]* )
		echo 313 > /sys/class/gpio/export
		echo out > /sys/class/gpio/gpio313/direction
		echo "DIGITAL_IO_CH5 OFF"
		echo 0 > /sys/class/gpio/gpio313/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH5 ON"
		echo 1 > /sys/class/gpio/gpio313/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH5 OFF"
		echo 0 > /sys/class/gpio/gpio313/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH5 ON"
		echo 1 > /sys/class/gpio/gpio313/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH5 OFF"
		echo 0 > /sys/class/gpio/gpio313/value
		sleep $sleep_time
		echo "DIGITAL_IO_CH5 ON"
		echo 1 > /sys/class/gpio/gpio313/value
		echo 313 > /sys/class/gpio/unexport
		;;
	* )
		echo "Wrong choice"
		;;
esac

