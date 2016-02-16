#!/bin/sh

### By John E. Herreño from Keeping your Drupal backups under control
### http://jeh3.net/keeping-your-drupal-backups-under-control 
# Recent X backups script for use with Drush
#
# Arguments:
# $1: Drupal's directory path
# $2: subfolder, relative to the default backup folder, do not include
#     leading or trailing slash
# $3: number of recent backups to keep in the folder on which the backup
#     will be saved (either the default one or a subfolder)
#
 
# Check params
USAGEMSG="\nMissing args error, usage is:\n  script.sh /path/to/drupal backup/subpath last-N-to-keep"
if [ ! -n "$1" ] ; then
  echo "$USAGEMSG"
  exit
elif [ ! -n "$2" ] ; then
  echo "$USAGEMSG"
  echo "\nMissing arg 2.\n  Second argument is path relative to ~/drush-backups/scheduled.\n  If the given subfolder does not exist, it will be created.\n  Do not include leading or trailing slash."
  exit
elif [ ! -n "$3" ] ; then
  echo "$USAGEMSG"
  echo "\nMissing arg 3.\n  Specify the number of recent copies to keep in \n  given backup-subfolder"
  exit
fi
 
# Unique suffix - use dates to easily find oldest files to delete
SUFFIX=$(date +%F-%H%M%S)
 
# Base path on which to perform all tasks
BASEPATH=$(echo ~/drush-backups/scheduled)
 
# Define the full path to the backup folder, allowing passing a subfolder to the script
BKPATH="$BASEPATH/$2"
BKFILE="$BKPATH/bk-$SUFFIX.tar.gz"
 
mkdir -p $BKPATH
 
cd $1
~/drush/drush arb --destination=$BKFILE
 
cd $BKPATH
COUNT=$(find . -maxdepth 1 -type f | wc -l)
while [ "$COUNT" -gt $3 ]; do
  find . -maxdepth 1 -type f | sort | head -n 1 | xargs rm
  COUNT=$(find . -maxdepth 1 -type f | wc -l)
done
