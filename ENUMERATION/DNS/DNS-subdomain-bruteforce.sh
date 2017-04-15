#!/bin/bash
# bruteforce subdomains
# using /usr/share/wordlists/dnscan subdomains wordlists
# usage: edit mydomain.com


for domain in $(cat /usr/share/wordlists/dnscan/subdomains-100.txt);
do host $domain.mydomain.com;sleep 2;done | grep has | sort -u
