# Drush archive-dump Backup
A script to be called by cron to automate backups of Drupal sites via the [Drush archive-dump(aliases ard, archive-backup, arb) command](http://drushcommands.com/drush-7x/core/archive-dump/).

**Currently this is a work in progress. Use this project at your own risk.**

## Planned for inclusion in this project
(may or may not already be implemented)
1. Backup script to be run by cron.
2. Backup archive made by Drush archive-dump command.
3. Reuse configuration in Drush aliases for configuration.
4. Separate configuration file.
5. Transfer to remote backup location via scp.
6. Logging
7. Notifications via email and Pushbullet.
8. Backup file management - What backups are kept and how long.
9. Configuration in configuration file can be overridden on the command line with options.
10. Will work in a jailed shell.

## Backup Filenames
**subdomain.domain.tld_yyyy-mm-dd_dow.tar.gz**

* **subdomain.domain.tld**  ie. testing.example.com
* **yyyy**  4 digit year
* **mm** 2 digit month
* **dd** 2 digit day of month
* **dow** 1 digit day of week, 1=Monday

## ~~Sub-folder~~
~~For each site an option will be given to place backups for a website in a sub-folder.~~

## Installation
1. Either copy `ard-bk-cron.sh` and `ard-bk.conf.example` to your scripts folder on the server you want to backup or clone this git repository on your server.
```bash
git clone https://github.com/meosch/drush_archive-dump_backup.git
```
I normally use `/home/username/bin/` for scripts.
2. Rename `ard-bk.conf.example` to `ard-bk.conf`. Then edit the file and adjust the configuration options to your needs.
3. Check your Drush alias file(s) (normally found in `~/.drush/`) to ensure that you have the correct values for **uri** and **root** for the site(s) that you wish to backup.
4. Ensure that you have setup passwordless login for the remote user and server where you wish to copy the files.
5. Test the script on the command line with something like:
```
~/bin/drush_archive-dump_backup/ard-bk-cron @example
```
6. Setup a cron job to run the backup job as often as you like.

## Batch Script
An example batch script has been included to allow easy setup with one cron job of the backup of multiple Drupal sites on one server.

1. Copy `ard-bk-cron-batch.sh.example` to `ard-bk-cron-batch.sh`.
2. Add command lines like you would in cron for each site to be backed up.
3. Add a cron job to run `ard-bk-cron-batch.sh`.
