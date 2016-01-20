#!/bin/bash
###########################################################################################
# File name: puppet-agent-install.sh
# Date: 6/4/2015
# Created By: Hanan Cohen <nonoe0@gmail.com>
#
###########################################################################################


HOST=$1
USER=$2
KEY=" -i $3 "

if [ ! $3 ]
  then
	KEY=""
fi
if [ ! $USER ]
  then
	USER=<std_sys_user/deploy_user>
fi

  scp $KEY ./set_hostname.sh $USER@$HOST:/tmp/.
  ssh -t $KEY $USER@$HOST "sudo sh /tmp/set_hostname.sh $HOST"

grep "CentOS Linux release 7.*" /etc/centos-release
ret=$?
if [ $ret -eq 0 ]; then
	
	ssh -t $KEY $USER@$HOST "sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm"
	sed -i '19s/enabled=0/enabled=1/g' /etc/yum.repos.d/puppetlabs.repo
	echo "Puppet Agent installed on CentOS 7"
	
else
	ssh -t $KEY $USER@$HOST "sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm"
	echo "Puppet Agent installed on CentOS 6"
fi

ssh -t $KEY $USER@$HOST "sudo yum -y install puppet"
ssh -t $KEY $USER@$HOST "sudo mv /etc/puppet/puppet.conf /etc/puppet/puppet.conf.orig"


scp $KEY ./puppet-agent.conf $USER@$HOST:/tmp/puppet-agent.conf

ssh -t $KEY $USER@$HOST "sudo mv /tmp/puppet-agent.conf /etc/puppet/puppet.conf" 

ssh -t $KEY $USER@$HOST "sudo puppet resource service puppet ensure=running enable=true"
