#!/bin/bash
# Add line numbers to debug output
PS4=':${LINENO} + '
# Debug
#set -x

####################################################################
### This script is used to purge backups.

###### CONFIGURATION ######
# Place configuration in the ~/.purgemeosbackups
if [[ -f $HOME/.purgemeosbackups ]]; then
# shellcheck source=/home/fhenderson/.purgemeosbackups
  source $HOME/.purgemeosbackups
else
  echo "configuration file $HOME/.purgemeosbackups not found."
  echo "Nothing more to do. Exiting!"
  exit
fi
###### Check if we have the needed command line tools. ######
### purgeFiles - A simple utility for smartly purging backup directories.
### by John Quinn (doofdoofsf on Github)
### http://www.johnandcailin.com/blog/john/smartly-purge-your-old-backup-files-linux
### https://github.com/doofdoofsf/purgeFiles
commandlinetools="purgeFiles"
if  ! command -v "${commandlinetools}" >/dev/null 2>&1; then
  echo "I require ${commandlinetools} but it's not installed.  Aborting."
  exit 1
fi

###### FUNCTIONS ######

# Purges MEOS Backups using the configuration above.
function purgemeosbackups(){
  # use for loop read all filenames
  for websitename in ${websitesArray[*]}
  do
    purgeFiles -p "$websitename-*" -d "${backupsdirectory}" -a "${ages}" --force # Comment out the --force option to test with a dry-run.
  done
}

function finished(){
  echo "All done cleaning up the backups directory for: "${websitesArray[*]}
}

function main_program(){
purgemeosbackups
finished
}

###### MAIN PROGRAM ######
# Log output to logfile
{ main_program |
  logger --priority user.notice --tag "$(basename "$0")"; } 2>&1 |
  logger --priority user.error --tag "$(basename "$0")"
finished
