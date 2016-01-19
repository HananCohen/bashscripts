#!/bin/bash

###########################################################################################
# File name: phpscript.sh
# Date: 12/1/2015
# Created By: Hanan Cohen <nonoe0@gmail.com>
#
###########################################################################################


date=`date +%m-%d-%y`
log=/var/log/log.log
csv_path=/path/to/file
csv_file=${csv_path}/filename_${date}.csv
#step 1 - call and run php script

#`which php` /path/to/voip_leads_to_csv.php  >> ${log} 2>&1
ret=$?

#step 2 - send the csv to mail group 

if [ $ret -eq 0 ]; then
	echo "Report sent to you by WWW01 server" | mail -s "Report for ${date}" -a ${csv_file} name@domain.com 
	if [ $? -ne 0 ]; then
		echo "cannot send mail" >> ${log}
		exit 1
	fi
	
else
	echo "CSV file did not created" >>${log}
	exit 1
fi

echo "email sent succesfully" >>${log}
