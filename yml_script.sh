#!/bin/bash
###########################################################################################
# File name: yml_script
# Date: 12/6/2015
# Created By: Hanan Cohen <nonoe0@gmail.com>
# purpose: to deploy multiple dokcer environments with yml compose/*.yml files 
#
###########################################################################################


#Folder as a var for where to execute the script 

PATH=$1

LOG=tmplog.log

#Varify that the folder is exist and print ret code to log

cd ${PATH}

ret=$?
if [ $ret -ne 0 ]; then
	echo " `date` Action fail to execute" >>${LOG}
	exit 1
fi

#VAR definition 

YML=/var/tmp/ymlfile.csv

#exporting all yml file in folder to csv file

ls ${PATH}*.yml > ${YML}

#Read the ymlfile and execute the docker command line by line

flag=0	  
while IFS= read -r line 
do	
	[ -f "${YML}" ] && sudo docker-compose -f ${line} up -d
	ret=$?
	
	if [ $ret -ne 0 ]; then
		echo " `date` Action on ${line} fail to execute" >>${LOG}
		flag=1
	fi	
done < ${YML}

#Send the script information to log with flags 
	
if [ $flag -eq 0 ]; then
	echo " `date` Action sucssesfuly completed"
	exit 0
else
	echo " `date` Action fail to execute"
	echo ${LOG}
	exit 1
fi