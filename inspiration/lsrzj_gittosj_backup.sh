#!/bin/bash

### By Leandro Scott R. Z. Jacques (lsrzj) and Jonathan Gittos (gittosj) from "Script that I created to automate the backup process using drush"
### https://www.drupal.org/node/470114
### gittosj version with the top comments added back in.

#=======================================================================
# Script developed by Leandro Scott R. Z. Jacques
# Version: 1.0 stable
#
#Script to backup all site's databases installed under the Drupal CMS platform. This Script
#dumps the sites database tables and store them compressed in a specified directory for
#3 days and then sends them to a backup mirror server using SCP.
#
#OBS: For each new installed site it must be included the backup routine commands for it's
#backup inside the backup block of the script. The backup control block defines how many
#days the backup will be stored and for which mirror server the backup will be sent.
#=======================================================================

TIMESTAMP=`date '+%y%m%d%H%M%S'` #Creates a timestamp for the file name in the format "yymmddHHMMSS"
NON_ROOT_EXIT=1 #Script errorlevel if it was not executed by root
EXIT_SUCCESS=0 #Script errorlevel if it was executed without problems
ROOT_UID=0 #Root UID to be compared with the user's UID executing the script
DIR=/directoryof/drupal/site
URI=http://urlofsite.com
HANDLE=name_for_labelling_backups

if [ "$UID" -ne "$ROOT_UID" ] #If user executing script not root then abort
then
echo "You need to be root to execute this script"
exit $NON_ROOT_EXIT
fi
#=========================================BACKUP BLOCK============================================
drush --root=$DIR --uri=$URI cache-clear all #for small sites it's good clearing cache to reduce backup size
drush --root=$DIR --uri=$URI ard --destination=/path/for/local_backups/${HANDLE}_${TIMESTAMP}.tar.gz
#====================================END OF BACKUP BLOCK=====================================

#===================================BACKUP CONTROL BLOCK====================================
cd /path/for/local_backups #go to the directory where backups are stored
#Remove older than 3 days backups
find . -mtime +2 -type f -exec rm -f '{}' \;
#Sends the newly created backups to a backup mirror server using SCP(with an authorized key without password on the remote server)
su ssh_user -c "find . -type f -mmin -1 -exec scp '{}' ssh_user@remoteserver.com:/path/for/backups_on_remote/ \;"
#=================================END OF BACKUP COTROL BLOCK==================================

exit $EXIT_SUCCESS
