#!/bin/sh

# (I know config is called from udev_program.sh) keep config also here so it's easy to dev
BASEDIR=$(dirname $0)
. $BASEDIR/config.sh

# some line might rely that settings directory exists
mkdir -p $wget_sync_settings

# ensure that application is installed
$wget_sync_home/install_app.sh

# wait that internet connection is established
date
echo "$0: connecting..."
$wget_sync_home/ping-test.sh www.google.com
if [ $? != 0 ]; then
    echo "$0: no connection"
    exit 1;
fi
echo "$0: connected"
# ensure that SD card is ready or create virtual SD card
$wget_sync_home/virtual_sd.sh

cd $wget_sync_libfolder
# check if we should reset authentication code
if [ -e $wget_sync_settings/config.sh ]; then
    echo "$0: Loading config.sh.";
    source $wget_sync_settings/config.sh
else
    echo "Did not find $wget_sync_settings/config.sh. Exiting"
    exit 1
fi

#check configuration
if [ -z "${url+xxx}" ] || [ -z "${exts+xxx}" ]; then 
    echo "Incomplete configuration. Please edit $wget_sync_settings/config.sh. Make sure url and exts are defined. Exiting"
    exit 1
fi

#If ssl certificate exists
if [ -e "$wget_sync_settings/cert.crt" ]; then
    ssl_auth="--ca-certificate=$wget_sync_settings/cert.crt"
fi

#synchronize
echo "$0: Starting Sync";
pwd

mkdir -p "$wget_sync_libfolder"
numdirs=$(($(echo "$url" | grep -o "/" | wc -l) - 2))
#get everything with wget, if this fails then everything fails..
wgetoutput=$(wget --user="$http_username" --password="$http_password" --mirror "$ssl_auth" --cut-dirs=$numdirs -P "$wget_sync_libfolder" --no-parent --no-host-directories --accept "$exts" "$url/" 2>&1 )
#TODO: exit status doesn't work apparently..
wgetstatus=$?
if [ $wgetstatus -ne 0 ]; then
    echo "Something went wrong. Stopping."
    exit 1
fi
echo "$wgetoutput"
#catch the rejections to subtract from total downloads.
urllength=${#url}
urllength=$((urllength+1))
log1loc=$(echo "$wgetoutput" | grep -Eio https?://.+ | cut -c $urllength- | grep -v '.*/$')
fixurls ()
{
    echo "$log1loc" | while read line
        do name="$wget_sync_libfolder$(echo -e "$line" | sed 's % \\\\x g' | xargs printf )"
        echo "$name"
    done
}
result=$(fixurls)
echo "$result"
numindexes=$(echo "$wgetoutput" | grep -o "since it should be rejected." | wc -l)
wgetresult=$(echo "$wgetoutput" | tail -1)
numdownloads=$(echo "$wgetresult" | grep -o '[0-9]\+\sfiles' | grep -o '[0-9]\+')
echo "----"
echo "Start removing files:"
currentfiles=$(find "$wget_sync_libfolder" -type f -print ! -iname ".*" -o \( -path $grive_sync_libfolder/Digital\ Editions -prune \) -type f -o \( -path $grive_sync_libfolder/koboExtStorage -prune \) -type f)
dostuff () 
{
    echo "$currentfiles" | while read i; do
        echo "$result" | grep -qF "$i"
        if [ $? -ne 0 ]
        then
            echo "@Removing $i..\n"
            rm "$i"
            if [ $? -ne 0 ]; then
                echo "Could not delete $i. Stopping"
                exit 1
            fi
        fi
    done
}
removefiles=$(dostuff)
echo $removefiles
echo $removefiles | grep -qF "@Removing"
deletestatus=$?
find "$wget_sync_libfolder" -depth -mindepth 1 -type d -exec rmdir --ignore-fail-on-non-empty '{}' +
echo "Done removing files"
echo "----"
numrealdownloads=$((numdownloads - numindexes))
echo "Num indexes: $numindexes | Num downloads: $numrealdownloads"
echo "----"
echo "Sync complete"
echo "----"
if [ $numrealdownloads -ne 0 ] || [ $deletestatus -eq 0 ]; then
    echo "$0: $modified_files_count new file(s). Refresh library.";
    $wget_sync_home/refresh_library.sh
else 
    echo "$0: No new files. Skip library refresh.";
fi
