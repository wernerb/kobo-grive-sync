#!/bin/sh

# This config script is used with sourcing so don't call exit

# wget_sync_home is also defined in /etc/udev/rules.d/99-wget-sync.rules and rcS_payload.txt

wget_sync_settings=/mnt/onboard/.wget-sync
wget_sync_home=/usr/local/wget-sync
wget_sync_libfolder=/mnt/onboard/.wget-sync/sd

export wget_sync_settings wget_sync_home wget_sync_libfolder