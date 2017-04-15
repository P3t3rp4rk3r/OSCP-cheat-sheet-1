# This is an nc port scanner
# can specify range. Instead of 80, do 1-65535
# scans TCP
# for UDP do nc -unvv -w 1 -z 192.168.x.x 160-165

> /tmp/ncscan.txt
for ip in $(seq 1 5);
	do nc -nvv -z 192.168.1.$ip 80 &>> /tmp/ncscan.txt
done
sleep 1; 
grep -i open --color /tmp/ncscan.txt;
