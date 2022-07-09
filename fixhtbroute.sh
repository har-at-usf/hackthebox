#!/bin/bash


# Adjust the HackTheBox gateways so you can load webpages.
# 
# Arguments:
#
#  $1	The default gateway's IP address (usually, 10.10.xxx.yyy)
#  $2	The default gateway's device (usually, tun0)
#
# Based on the explanation given here:
#	https://bobmckay.com/i-t-support-networking/ethical-hacking/hackthebox-vpn-internet-not-working-aka-enable-split-tunneling-on-htb-vpn/

# Set the IP address.
ip=$1

# Set this to whatever device HTB defaults to (usually, tun0).
device="tun0"

# If the user specifies a device, set it.
if [[ $2 ]]; then
	device=$2
fi

# Make sure the device exists for any of the default gateways (sloppy validation).
exists=$(route | grep $1 | grep $device)

# IP validation. If the user specified the device, make sure it exists.
if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ && $exists ]]; then
	
	sudo route del \
		-net \
		default gw "$1" \
		netmask 0.0.0.0 \
		dev $device
		
	# Notify the user on success.
	echo -e "\nRemoved gateway [ $ip : $device ]\n"
	route | grep $ip | grep $device

# If an error occurs, choose the IP and device from the list of default gateways.
else
	echo -e "\nERROR: Invalid IP or Device."
	echo -e "\nChoose the HackTheBox route and device from the list:"
	route | grep "default"

	echo -e "\nUsage: fixhtbroute.sh [htb gateway] [vpn device]"
	echo -e "\nExample: ./fixhtbroute.sh 10.10.11.166 tun0\n"
fi
