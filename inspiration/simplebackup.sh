#!/bin/bash
#
### By Dale Mcgladdery from Simple Drupal Remote Backup
### http://www.group42.ca/simple_drupal_remote_backup

# Backup the Group 42 live site
#
FILENAME=`date "+group42-%Y-%m-%d.tar"`
drush @g42live archive-dump --destination=/home/site/backuptemp/$FILENAME
scp user@example.com:/home/site/backuptemp/$FILENAME /Volumes/Memory-Alpha/Backups/Group42/.
ssh user@example.com rm /home/site/backuptemp/$FILENAME
