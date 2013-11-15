#!/bin/sh

# create virtual SD card by bind mounting it to folder inside onboard SD.
mkdir -p $wget_sync_settings/sd/
mountpoint -q /mnt/sd
if [ $? -eq 0 ]; then
      echo "$0: /mnt/sd is already mounted. Nothing done."
      exit 1;
fi
echo "$0: Creating bind mount."
mount --bind $wget_sync_settings/sd /mnt/sd