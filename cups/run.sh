#!/bin/sh

#add user
useradd -G lpadmin -M -s /usr/sbin/nologin $CUPS_USER

echo "$CUPS_USER:$CUPS_PASS" | chpasswd

#set CUPS options
cupsd

sleep 1

cupsctl --remote-admin --remote-any --share-printers \
    DefaultEncryption=Never \
    MaxLogSize=0

sleep 1

if [ -n "$CUPS_SERVER_ALIAS" ]; then
    cupsctl "ServerAlias='${CUPS_SERVER_ALIAS}'"
fi

sed -i -e "s/^AccessLog .*$/AccessLog stderr/" /etc/cups/cups-files.conf
sed -i -e "s/^PageLog .*$/PageLog stderr/" /etc/cups/cups-files.conf
sed -i -e "s/^ErrorLog .*$/ErrorLog stderr/" /etc/cups/cups-files.conf

sleep 1

PID=$(pgrep cupsd)

kill $PID

sleep 1

#run CUPS
exec cupsd -f
