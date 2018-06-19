#!/bin/sh

TMPL="gcp-cups-connector.config.json.tmpl"
CONFIG="gcp-cups-connector.config.json"

if [ -z "$CUPS_SERVER" ]; then
    echo "CUPS_SERVER must be set"
    exit 1
fi

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

exec /gcp-cups-connector --log-to-console
