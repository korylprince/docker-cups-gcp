#!/bin/sh

TMPL="gcp-cups-connector.config.json.tmpl"
CONFIG="gcp-cups-connector.config.json"

if [ -z "$CUPS_SERVER" ]; then
    echo "CUPS_SERVER must be set"
    exit 1
fi

jq ".xmpp_jid=\"$XMPP_JID\" | .robot_refresh_token=\"$REFRESH_TOKEN\" | .proxy_name=\"$PROXY_NAME\"" $TMPL > $CONFIG

exec /gcp-cups-connector --log-to-console
