#!/bin/sh
#create build directory
mkdir -p build/KoboRoot

#see http://maemo.org/packages/package_instance/view/diablo_extras_free_armel/wget/1.10.2-2osso2/
wgeturl="http://repository.maemo.org/extras/pool/diablo/free/w/wget/wget_1.10.2-2osso2_armel.deb"
localmd5="cd89139a3148b9f4a2b55d712059f106"

if [ ! -f build/wget.deb ];
then 
	wget "$wgeturl" -O build/wget.deb
fi
md5=`md5sum build/wget.deb | awk '{ print $1 }'`
if [ $localmd5 != $md5 ]
then
	echo "Bad wget."
	exit 1
fi

cd build
ar -vx wget.deb
#create clean KoboRoot with just wget
tar -zxvf data.tar.gz -C KoboRoot
#add our wgetsync to it.
cp -r ../src/* KoboRoot
#package it
tar cvzf KoboRoot.tgz -C KoboRoot .