#!/bin/bash
###########################################################################################
# File name:BDscript.sh
# Date: 12/11/2015
# Created By: Hanan Cohen <nonoe0@gmail.com>
#
###########################################################################################


# Check number of parameters is equal to 1 (the csv file)
# If not, print help

#VAR definition 
admin=deploy_dba
password=9Baa2ZXRn9

# Get csv file as parameter
filename=$1

exit_code=0

# Read users from CSV file  
sed 1d $filename | while IFS=, read user paswd db_name db_host from priv
do
    echo "$user $paswd $db_name $db_host $from $priv"
	
	# Check if connection to DB is OK
	# If not, print message
	
	Result=`mysql -u $admin -p$password -h $db_host --skip-column-names -e "SHOW DATABASES LIKE '$db_name'"`
	if [ "$Result" = "$db_name" ]; then
	
		#Grant priviliges on DB  
		Q1="GRANT $priv ON $db_name.* TO '$user'@'$from' IDENTIFIED BY '$paswd';"
		Q2="FLUSH PRIVILEGES;"
		SQL="${Q1}${Q2}"
	
		mysql -h $db_host -u $admin -p"$password" $db_name -e "$SQL"
	    
	else
	    echo "Action Fail On Row: $user $paswd $db_name $db_host $from $priv"
		exit_code=1
	fi
	
done 

if [ $exit_code = 1 ]; then
	echo "Somthing went wrong"
else 
	echo "All lines were OK"
fi

exit $exit_code