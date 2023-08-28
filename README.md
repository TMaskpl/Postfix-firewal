# Postfix-firewal

### Add to firehol black list

ipv4 ipset create badguys hash:ip

ipv4 ipset addfile badguys /etc/firehol/file-with-the-bad-guys-ips.txt

ipv4 blacklist full ipset:badguys
