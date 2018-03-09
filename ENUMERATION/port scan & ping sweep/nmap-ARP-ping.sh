#!/bin/bash
# ARP ping with nmap
nmap -sP -PR 10.11.1.0/24 -oG nmap-arp.txt
