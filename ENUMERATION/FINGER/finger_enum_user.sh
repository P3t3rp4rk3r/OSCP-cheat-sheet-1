#!/bin/bash

# http://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable
display_usage()
{
	echo -e "\nScript takes a file with a list of users as argument"
	echo -e "Usage:\n./finger_enum_user.sh <filename.txt>\n"
}

if [ $# -le 0 ]
then
	display_usage
	exit 1
fi

while IFS='' read -r line || [[ -n "$line" ]]; do

	echo "User :" $line
	finger $line@192.168.1.33
	echo -e "\n"

done < "$1"
