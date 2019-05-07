#!/bin/bash
# Drush archive-dump backup cron
# MEOS - Frederick Henderson
# https://github.com/meosch/drush_archive-dump_backup
# This script is used to make a archive-dump of the files and database for a
# Drupal Website. It is intended to be scheduled to run by cron.
PS4=':${LINENO} + ' # For development, next line too
#set -x
scriptdir=$(dirname "$BASH_SOURCE")
# Get configuration file
source ${scriptdir}/ard-bk-dr6.conf

# Console colors
red='\033[0;31m'     # ${red}
green='\033[0;32m'   # ${green}
yellow='\033[1;33m'  # ${yellow}
NC='\033[0m'         # ${NC} back to Normal Color

# Check options given on the command line
USAGEMSG="\nI need the Drush Alias of a site to backup. Usage:\n${yellow}$ ${green}ard-bk-cron.sh ${red}@mysite${NC}\n"
if [ ! -n "$1" ] ; then
  echo -e "$USAGEMSG"
  exit
fi
drushalias="$1"

function findcommands(){
# Where is drush?
#  drush=$(which drush6)
drush="/opt/alt/php53/usr/bin/php /home/cmnetorg/.composer/drush-6/vendor/drush/drush/drush.php"
}

function getdrushconfig(){
## Get configuration from Drush alias file. root and uri must be set in the
## drush alias file for the domain to backup. See the example file for more info.
## https://github.com/drush-ops/drush/blob/master/examples/example.aliases.drushrc.php

# Domain name of website to backup
  domainname=$(${drush} sa ${drushalias} --fields=uri --field-labels=0 --format=list)
# Path of the webroot of the Drupal website to backup
  drupalwebroot=$(${drush} sa ${drushalias} --fields=root --field-labels=0 --format=list)
}

function makefilename(){
  #Date and time in the following format to give us the most flexibility with
  # keeping and deleting backups.
  # YYYY-mm-dd-WW-X-HHMMSS
  # YYYY = 4 digit year
  # mm = 2 digit month
  # dd = 2 digit day of month
  # WW = 2 digit week of year
  # X = 1 digit day of week (1..7); 1 is Monday
  # HH = 2 digit hour (00..23)
  # MM = 2 digit minutes
  # SS = 2 digit seconds

  date_time=$(date "+%Y-%m-%d-%V-%u-%H%M%S")
  filename=${domainname}-${date_time}.tar.gz
}

function createarchivedump(){
  ${drush} ${drushalias} archive-dump --destination=${localbackupbasepath}/${filename} --overwrite
}

function scptoremote(){
while true; do command scp ${localbackupbasepath}/${filename} ${remotebackupuserandserver}:${remotebackupbasepath}/${filename}; [ $? -eq 0 ] && break || sleep 5;
done
}

function removelocalbackup(){
  rm ${localbackupbasepath}/${filename}
}

function finished(){
  echo ""
  echo -e "${yellow}>>>${NC} All done archiving and transfering ${yellow}${domainname}${NC}."
}
###### MAIN PROGRAM #######
findcommands
getdrushconfig
makefilename
createarchivedump
scptoremote
removelocalbackup
#finished # Only used for local testing.
