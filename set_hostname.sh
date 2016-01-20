#!/bin/bash
###########################################################################################
# File name: set_hostname.sh
# Date: 12/1/2015
# Created By: Hanan Cohen <nonoe0@gmail.com>
#
###########################################################################################


IPADDR=`ip addr list eth0 |grep "inet "| cut -d ' ' -f6|cut -d/ -f1`
hostname $1
sed -i.save s/HOSTNAME=.*/HOSTNAME=$1/g /etc/sysconfig/network
echo "$IPADDR $1" >> /etc/hosts
