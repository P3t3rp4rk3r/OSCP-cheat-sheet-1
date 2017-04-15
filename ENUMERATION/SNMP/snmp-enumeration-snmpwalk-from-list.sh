#!/bin/bash
#for mib in $(cat /root/exercises/mibs.txt);do snmpwalk -c public -v1 $ip $mib;done
#while read i ; do snmpwalk -c public -v1 $ip $i ; done < /root/exercises/mibs.txt

for ip in $(cat /root/exercises/snmphosts2.txt);do snmpwalk -c public -v1 $ip 1.3.6.1.4.1.77.1.2.25;done
