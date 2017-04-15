#!/bin/bash
#Simple Zone Transfer Bash Script
# $1 is the first argument given after the bash script
# Check if argument was given, if not, print usage
# usage: ./file.sh domain.com

if [ -z "$1" ]; then
	echo "[*] Simple Zone transfer script"
	echo "[*] Usage:	: $0 <domain name> "
	exit 0
fi

#if argument was given, identify the DNS servers for the domain.
#For each of thse servers, attempt a zone transfer

for server in $(host -t ns $1 | cut -d" " -f4);do
	host -l $1 $server | grep "has address"
done
