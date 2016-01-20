#!/bin/bash

###########################################################################################
# File name: pull-puppet.sh
# Date: 17/5/2015
# Created By: Hanan Cohen <nonoe0@gmail.com>
#
###########################################################################################



if [ $# -ne 1 ];
        then echo "must have 1 parameter: env1 / env2"
        exit 1
fi
env=$1

echo "Started at: `date`"
echo "--------------------------------------"

cd /home/repos/puppet
git pull

sudo rsync -va --exclude=.git --delete /home/repos/puppet/ /etc/puppet

case "$env" in
env1
        rm -f /etc/puppet/puppet.conf
        sudo ln -s /etc/puppet/puppet-env1.conf /etc/puppet/puppet.conf
        echo "Set puppet conf to env1"
        ;;
env2)
        rm -f /etc/puppet/puppet.conf
        sudo ln -s /etc/puppet/puppet-env2.conf /etc/puppet/puppet.conf
        echo "Set puppet conf to env2"
        ;;
*)
        echo "First parameter must be 'env1' or 'env2'"
        echo "Existing - Run again"
        exit 1
        ;;
esac

sudo chown -R root:root /etc/puppet
sudo service puppetmaster restart

echo "Ended at: `date`"
echo "======================================="
echo
