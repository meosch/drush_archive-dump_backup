#!/bin/sh
 
### By Paul Booker from Daily Backup scheme for Drupal sites on an Ubuntu server
### http://www.paulbooker.co.uk/drupal-developer/command-lines/daily-backup-scheme-drupal-sites-ubuntu-server#
 
# Daily backup of the database, using Drush
# /usr/local/bin/daily-backup.sh
#
 
# Backup directory
DIR_BACKUP=/home/backup
 
log_msg() {
  # Log to syslog
  logger -t `basename $0` "$*"
 
  # Echo to stdout
  LOG_TS=`date +'%H:%M:%S'`
  echo "$LOG_TS - $*"
}
 
DAY_OF_WEEK=`date '+%a'`
BACKUP_FILE=$DIR_BACKUP/backup.$DAY_OF_WEEK.tgz
 
log_msg "Backing up files and database to $BACKUP_FILE ..."
 
drush @live archive-dump \
  --destination=$BACKUP_FILE \
  --preserve-symlinks \
  --overwrite 
 
RC=$?
 
if [ "$RC" = 0 ]; then
  log_msg "Backup completed successfully ..."
else
  log_msg "Backup exited with return code: $RC"
fi
