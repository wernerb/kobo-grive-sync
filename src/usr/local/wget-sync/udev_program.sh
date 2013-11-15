#!/bin/sh

# http://www.reactivated.net/writing_udev_rules.html#example-netif

if [ "$ACTION" != "add" ]; then
      exit 1;
fi

BASEDIR=$(dirname $0)
. $BASEDIR/config.sh

# some line might rely that settings directory exists
mkdir -p $wget_sync_settings

$BASEDIR/sync.sh &> $wget_sync_settings/last-wget-sync.txt &