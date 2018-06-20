#!/bin/sh

TMPL="gcp-cups-connector.config.json.tmpl"
CONFIG="gcp-cups-connector.config.json"

if [ -z "$FCM_ENABLED" ]; then
    FCM_ENABLED="false"
fi

if [ -z "$LOG_LEVEL" ]; then
    LOG_LEVEL="INFO"
fi

jq ".fcm_notifications_enable=$FCM_ENABLED | \
    .xmpp_jid=\"$XMPP_JID\" | \
    .robot_refresh_token=\"$REFRESH_TOKEN\" | \
    .proxy_name=\"$PROXY_NAME\" | \
    .log_level=\"$LOG_LEVEL\"" \
    $TMPL > $CONFIG

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
cupsd -f &

sleep 3

exec /gcp-cups-connector --log-to-console
