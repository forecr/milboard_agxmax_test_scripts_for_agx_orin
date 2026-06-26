#!/bin/bash
if [ "$(whoami)" != "root" ] ; then
	echo "Please run as root"
	echo "Quitting ..."
	exit 1
fi

# Check the scipts' folder
SCRIPTS_FOLDER=$(dirname $(realpath $0))
if [ $# -eq 1 ]; then
	SCRIPTS_FOLDER=$1
fi
if [ $# -gt 1 ]; then
	echo "Please type test scripts' folder path"
	echo "Please run as:"
	echo "sudo $0 <test_scripts'_full_path>"
	echo "Quitting ..."
	exit 1
fi
if [ -d "$SCRIPTS_FOLDER" ]; then
	if [ "${SCRIPTS_FOLDER: -1}" != "/" ]; then
		SCRIPTS_FOLDER="$SCRIPTS_FOLDER/"
	fi
	echo "$SCRIPTS_FOLDER folder exists"
	chmod +x $SCRIPTS_FOLDER/iperf3_*.sh
	chmod +x $SCRIPTS_FOLDER/test_*.sh
	echo "All script files made executable"
else
	echo "$SCRIPTS_FOLDER folder does not exist"
	echo "Quitting ..."
	exit 1
fi

function apt_install_pkg {
	REQUIRED_PKG=$1
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo "Checking for $REQUIRED_PKG: $PKG_OK"
	if [ "" = "$PKG_OK" ]; then
		echo ""
		echo "$REQUIRED_PKG not found. Setting it up..."
		sudo apt-get --yes install $REQUIRED_PKG 

		PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
		echo ""
		echo "Checking for $REQUIRED_PKG: $PKG_OK"

		if [ "" = "$PKG_OK" ]; then
			echo ""
			echo "$REQUIRED_PKG not installed. Please try again later"
			exit 1
		fi

	fi
}

# Check GtkTerm installed
apt_install_pkg 'gtkterm'

# Check gpiod installed
apt_install_pkg 'gpiod'


function check_nvgetty_service {
	echo -n "nvgetty.service status: "
	if [ "$(systemctl is-enabled nvgetty.service)" = "enabled" ]; then
		echo "enabled"
		sleep 2
		sudo systemctl disable nvgetty.service
		echo "Service disabled, rebooting now ..."
		sleep 10
		sudo reboot
	elif [ "$(systemctl is-enabled nvgetty.service)" = "disabled" ]; then
		echo "disabled"
	else
		echo "Failed to get unit file state -> No such file or directory"
		echo "Skipping..."
	fi
}


function test_menu {
	continue_test=true

	while $continue_test; do
		sleep 1
		echo ""
		echo "****************************"
		echo "*** Production Test Menu ***"
		echo "1) Previous Tests"
		echo "2) Disks (M.2 SSD and SD card) Test"
		echo "3) Network Speed Test"
		echo "4) Local Network Test (iperf3)"
		echo "5) Public Network Test (ping)"
		echo "6) USB Test"
		echo "7) RS-232 CH0 Test"
		echo "8) RS-232 CH1 Test"
		echo "9) RS-232 CH2 Test"
		echo "10) RS-232 CH3 Test"
		echo "11) RS-422 CH0 Test"
		echo "12) RS-422 CH1 Test"
		echo "13) RS-422 CH2 Test"
		echo "14) RS-422 CH3 Test"
		echo "15) CAN Bus CH0 Transmit Test"
		echo "16) CAN Bus CH0 Receive Test"
		echo "17) CAN Bus CH1 Transmit Test"
		echo "18) CAN Bus CH1 Receive Test"
		echo "19) Digital I/O CH0 Test"
		echo "20) Digital I/O CH1 Test"
		echo "21) Digital I/O CH2 Test"
		echo "22) Digital I/O CH3 Test"
		echo "23) Digital I/O CH4 Test"
		echo "24) Digital I/O CH5 Test"
		echo "25) Digital I/O CH6 Test"
		echo "26) Digital I/O CH7 Test"
		echo "27) 6-AXIS IMU & Temperature Sensor Test"
		echo "28) Fan Test"
		read -p "Type the test number (or quit) [1/.../q]: " CHOICE
		echo ""

		case $CHOICE in
			1 ) 
				echo "* Set the device in recovery mode, connect recovery USB and check the device in recovery mode with lsusb (0955:7*23)"
				echo "* Reset the device, connect Debug USB and check the serial connection"
				;;
			2 )
				echo "Check M.2 SSD and SD card detected"
				gnome-terminal -- gnome-disks
				;;
			3 )
				echo "Network Speed Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_net_speed.sh
				;;
			4 )
				echo "Local Network Test"
				read -p "Server or Client (s/c): " NETWORK_CHOICE
				case $NETWORK_CHOICE in
					[Ss]* )
						gnome-terminal -- $SCRIPTS_FOLDER/iperf3_server.sh
						;;
					[Cc]* )
						gnome-terminal -- $SCRIPTS_FOLDER/iperf3_client.sh
						;;
					* )
						echo "Wrong choice"
						;;
				esac
				;;
			5 )
				echo "Public Network Test"
				gnome-terminal -- $SCRIPTS_FOLDER/test_public_net.sh
				;;
			6 )
				echo "USB Test"
				gnome-terminal -- watch -n 0.1 lsusb
				;;
			7 )
				echo "RS232 CH0 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs232_agx_orin.sh
				;;
			8 )
				echo "RS232 CH1 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs232_agx_orin.sh
				;;
			9 )
				echo "RS232 CH2 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch2_rs232_agx_orin.sh
				;;
			10 )
				echo "RS232 CH3 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch3_rs232_agx_orin.sh
				;;
			11 )
				echo "RS422 CH0 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch0_rs422_agx_orin.sh
				;;
			12 )
				echo "RS422 CH1 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch1_rs422_agx_orin.sh
				;;
			13 )
				echo "RS422 CH2 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch2_rs422_agx_orin.sh
				;;
			14 )
				echo "RS422 CH3 Test"
				check_nvgetty_service
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_ch3_rs422_agx_orin.sh
				;;
			15 )
				echo "CAN Bus CH0 Transmit Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can0_transmit_agx_orin.sh
				;;
			16 )
				echo "CAN Bus CH0 Receive Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can0_receive_agx_orin.sh
				;;
			17 )
				echo "CAN Bus CH1 Transmit Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can1_transmit_agx_orin.sh
				;;
			18 )
				echo "CAN Bus CH1 Receive Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_can1_receive_agx_orin.sh
				;;
			19 )
				echo "Digital I/O CH0 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch0_agx_orin.sh
				;;
			20 )
				echo "Digital I/O CH1 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch1_agx_orin.sh
				;;
			21 )
				echo "Digital I/O CH2 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch2_agx_orin.sh
				;;
			22 )
				echo "Digital I/O CH3 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch3_agx_orin.sh
				;;
			23 )
				echo "Digital I/O CH4 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch4_agx_orin.sh
				;;
			24 )
				echo "Digital I/O CH5 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch5_agx_orin.sh
				;;
			25 )
				echo "Digital I/O CH6 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch6_agx_orin.sh
				;;
			26 )
				echo "Digital I/O CH7 Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_digital_io_ch7_agx_orin.sh
				;;
			27 )
				echo "6-AXIS IMU & Temperature Sensor Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_wsen_isds_imu.sh -i 0.1
				;;
			28 )
				echo "Fan Test"
				sudo gnome-terminal -- $SCRIPTS_FOLDER/test_fan.sh
				;;
			[Qq]* )
				echo "Quitting ..."
				exit 1
				;;
			* )
				echo "Wrong choice"
				;;
		esac
	done
}


test_menu

