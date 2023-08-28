#!/bin/bash

##################################################
#                                                #
#__author__ = "biuro@tmask.pl"                   #
#__copyright__ = "Copyright (C) 2023 TMask.pl"   #
#__license__ = "MIT License"                     #
#__version__ = "1.0"                             #
#                                                #
##################################################

IP=$(pflogsumm -d today /var/log/mail.log | sed -n '/smtpd (total:/,/Fatal Errors/p' | tail -n+2 | head  -n -2 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

echo " "

l=0

for i in $IP
do
        grep $i /etc/firehol/file-with-the-bad-guys-ips.txt
        retVal=$?
        if [ $retVal -eq 0 ]; then
                echo "IP na liscie"
        else
                date=$(date '+%Y-%m-%d %H:%M:%S')
                echo "Dodano do listy IP $i -> $date"
                echo "$date -> TMask.pl firewall - Zablokowano IP $i" >> /var/log/syslog
                echo $i >> /etc/firehol/file-with-the-bad-guys-ips.txt
                l=$((l+1))
        fi
done

[ $l -gt 0 ] && {
        echo "Dodano nowych adresow IP - $l"
        firehol restart
}  
exit 0
