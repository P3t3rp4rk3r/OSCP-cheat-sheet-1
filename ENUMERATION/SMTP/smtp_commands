smtp-user-enum  //in Kali
smtp-user-enum -M VRFY -U /usr/share/wordlists/metasploit/unix_users.txt -t 10.11.1.22

SMTP sendmail commands:

bash-2.05a$ telnet localhost 25
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
220 barry ESMTP Sendmail 8.11.6/8.11.6; Sun, 20 Aug 2017 00:01:02 +0300
help
214-2.0.0 This is sendmail version 8.11.6
214-2.0.0 Topics:
214-2.0.0 	HELO	EHLO	MAIL	RCPT	DATA
214-2.0.0 	RSET	NOOP	QUIT	HELP	VRFY
214-2.0.0 	EXPN	VERB	ETRN	DSN	AUTH
214-2.0.0 	STARTTLS
214-2.0.0 For more info use "HELP <topic>".
214-2.0.0 To report bugs in the implementation send email to
214-2.0.0 	sendmail-bugs@sendmail.org.
214-2.0.0 For local information send email to Postmaster at your site.
214 2.0.0 End of HELP info
AUTH
503 5.3.3 AUTH mechanism  not available
EHLO barry
250-barry Hello localhost [127.0.0.1], pleased to meet you
250-ENHANCEDSTATUSCODES
250-EXPN
250-VERB
250-8BITMIME
250-SIZE
250-DSN
250-ONEX
250-ETRN
250-XUSR
250 HELP
AUTH LOGIN

