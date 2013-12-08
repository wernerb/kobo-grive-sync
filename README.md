kobo-wget-sync
===============

Forked from https://github.com/softapalvelin/kobo-grive-sync/. 
Thanks so much for the good work! Unfortunately, it does not seem to work for latter versions of kobo firmware.

So, instead of using grive, this uses wget instead which is pre-compiled for armel architecture and downloaded by the package script.

Purpose
---------------
When you have multiple kobo's and do not wish to keep connecting your kobo to your PC then this is for you. 
By serving a directory with _nginx_ or _apache2_ with a file listing (with authentication), you can serve files in your local network to be synced to all your kobo devices.
The sync script mirrors and spiders the various indexes of your web-url and only downloads the file extensions specified by you in the `.wget-sync/config.sh`.

After installing and configuring, you activate wifi (a quick way to activate wifi is to press `Sync`) and it will fetch new files from your webserver.
Additionally, because I use this for weekly news digests, it also deletes files that are no longer present on your webserver.
So be **careful!**

It also supports ssl and http authentication for obvious reasons.

Install
---------------

1. To build simply run the package script.

   ```
   ./package.sh
   ```

   Then copy the `build/KoboRoot.tgz` to your kobo's /.kobo directory and disconnect the kobo.
   You will see it updating and restart.

2. Press `Sync` or activate wifi to start the script. (It watches the activation of wifi through udev rules)
3. Connect your kobo again and a dir called `.wget-sync` should be created that contains `config.sh`
4. Edit `config.sh` by setting the url and other options.
5. Disconnect usb, activate wifi and your kobo should sync with the webserver file listing. If it does not go well you can check the log in `.wget-sync` to check what went wrong.


FAQ
--------------
```
Q: For what Kobo versions does this work?
A: I only tested this with the Kobo Glo with the latest firmware to date `2.10.0`. Please tell me if this works for you.

Q: Where are the books downloaded?
A: On onboard memory in /.wget-sync/sd/

Q: After the initial sync going well, my second sync doesn't work!
A: This script doesn't work on the "Sync" button, but rather on the activation of Wifi. So disabling and enabling wifi again will initialize the script.

Q: I have an external sd-card, can I still use this?
A: The script softapalvelin created uses an virtual sd card to trick kobo into thinking you inserted new content. So, maybe?

Q: Will you long-term support this?
A: No.
```
 
Disclaimer
---------------
My bash scripting skills are not that good, so backup everything and test this thuroughly if you wan to use it. And if you decide to use it, know that I will not be responsible for epubs or books lost.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/wernerb/kobo-wget-sync/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

