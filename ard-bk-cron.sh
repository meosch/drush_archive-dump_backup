#!/bin/bash
# Drush archive-dump backup cron
# MEOS - Frederick Henderson
# https://github.com/meosch/drush_archive-dump_backup
# This script is used to make a archive-dump of the files and database for a
# Drupal Website. It is intended to be scheduled to run by cron.
PS4=':${LINENO} + ' # For development, next line too
#set -x
scriptdir=$(dirname "$BASH_SOURCE")
# Get configuration files
if [ -f "${scriptdir}/ard-bk.conf" ]; then
  source ${scriptdir}/ard-bk.conf
fi
if [ -f "${scriptdir}/drush-versions.conf" ]; then
  source ${scriptdir}/drush-versions.conf
fi
if [ -f "${scriptdir}/php-versions.conf" ]; then
  source ${scriptdir}/php-versions.conf
fi
# Console colors
red='\033[0;31m'     # ${red}
green='\033[0;32m'   # ${green}
yellow='\033[1;33m'  # ${yellow}
NC='\033[0m'         # ${NC} back to Normal Color

# Check options given on the command line
USAGEMSG="\nI need the Drush Alias of a site to backup. Usage:\n${yellow}$ ${green}ard-bk-cron.sh ${red}@mysite${NC} [drush major version number] [php version as defined in php-versions.conf]\n If you want to set a php version you must also set the drush version and in the order in the usage statement above."
if [ ! -n "$1" ] ; then
  echo -e "$USAGEMSG"
  exit
fi
drushalias="$1"
drushversion="$2"
phpversion="$3"

function drushversion(){
# Do we need a special version of Drush or should we use the default?
if [ -n "${drushversion}" ]; then
  case "${drushversion}" in
    8)
      drush="${drush8}"
    ;;
    7)
      drush="${drush7}"
    ;;
    6)
      drush="${drush6}"
    ;;
  esac
    getdrushdefault
else
  if [ -n "${defaultdrushversion}" ]; then
    getdrushdefault
  else
    finddrush
  fi
fi
}

function getdrushdefault(){
  if [ -z ${drush} ]; then
    drush="${defaultdrushversion}"
  fi
}

function phpversion(){
  if [ -n "${phpversion}" ]; then
    pathtophp=$phpversion
    export DRUSH_PHP=${!pathtophp}
  else 
    if [ -n "${defaultpathtophp}" ]; then
      pathtophp="${defaultpathtophp}"
      export DRUSH_PHP=${pathtophp}
    fi
  fi
}

function finddrush(){
# Where is drush?
  drush=$(which drush)
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
  #Date and time in the following format to give us the most flexiablity with
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

  date_time=$(date "+%Y-%m-%d-%U-%u-%H%M%S")
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
drushversion
phpversion
getdrushconfig
makefilename
createarchivedump
scptoremote
removelocalbackup
finished
