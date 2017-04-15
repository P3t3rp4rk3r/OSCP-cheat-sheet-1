#!/usr/bin/python
# SMTP VRFY Scanner 
# verifies a user via SMTP VRFY
# syntax is ./SMTP-VRFY-scanner.py <username>

import socket
import sys
from netaddr import *

if len(sys.argv) != 2:
        print "Usage: vrfy.py <username>"
        sys.exit(0)
# Create a Socket
s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Connect to the Server
for ip in IPSet(["192.168.13.0/23"]):
	connect=s.connect(("IPRange",25))
# Recieve the banner
banner=s.recv(1024)
print banner
# VRFY a user
s.send('VRFY ' + sys.argv[1] + '\r\n')
result=s.recv(1024)
print result
# Close the socket
s.close()

