#!/bin/sh
target=/etc/init.d/rcS
payload=$wget_sync_home/rcS_payload.txt

grep -q -F -f $payload $target
if [ $? != 0 ]; then
	cat $payload >> $target
fi

target=/usr/local/Kobo/udev/usb
payload=$wget_sync_home/usb_payload.txt

grep -q -F -f $payload $target
if [ $? != 0 ]; then
	cat $payload >> $target
fi

target=$wget_sync_settings/config.sh
payload=$wget_sync_home/config_template.txt
if [ ! -f $target ]; then
	cat $payload > $target
fi