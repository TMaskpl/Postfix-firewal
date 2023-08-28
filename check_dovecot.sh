d=$(date | awk -F ' ' '{print $2, $3}')
cat /var/log/syslog | grep dovecot | grep "$d" | grep rip | grep fail | grep -Po '(?<=rip=)[^/]*' | awk -F ',' '{print $1}'
