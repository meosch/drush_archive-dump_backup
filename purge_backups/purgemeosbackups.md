# Purge MEOS Backups

The files in this folder are used to purge old backup files.

## Setup

There are two files plus the external **purgeFiles** script needed to purge MEOS Backups.

* `.purgemeosbackups` is a hidden user configuration file. Place it in the home directory (`~` = `$HOME` = `/home/username/`) of the user that will run the cron scripts and edit it to suit your setup.
* `purgemeosbackups.sh` is the cron script that you should run with cron. You can place this anywhere you like, but it could be helpful for testing to have it in your $PATH.
* [`purgeFiles`](https://github.com/doofdoofsf/purgeFiles) is the script used to purge the files. It is available on [Github ( doofdoofsf/purgeFiles)](https://github.com/doofdoofsf/purgeFiles). More information about   `purgeFiles` is available in the blog post [smartly purge your old backup files on linux](http://www.johnandcailin.com/blog/john/smartly-purge-your-old-backup-files-linux) by John Quinn (user doofdoofsf on Github(.) Place `purgeFiles` in the $PATH of the cron user that the cron job will run as.
