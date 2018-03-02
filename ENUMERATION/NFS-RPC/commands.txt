nmap -sV --script=nfs-* 192.168.44.133
nmap -sV --script=nfs-ls 192.168.44.133  //same result as rpcinfo
nmap -sV --script=nfs-* 192.168.44.133 // all nfs scripts

rpcinfo -p 192.x.x.x
rpcclient -I 192.x.x.x

#mount NTFS share
mount -t nfs 192.168.1.72:/home/vulnix /tmp/mnt -nolock

#enumerate NFS shares
showmount -e 192.168.56.103

# If you see any NFS related ACL port open, see /etc/exports
#   2049/tcp  nfs_acl
# /etc/exports: the access control list for filesystems which may be exported to NFS clients.  See exports(5).

READ:
https://pentestlab.blog/tag/rpc/

See root squashing
https://haiderm.com/linux-privilege-escalation-using-weak-nfs-permissions/

