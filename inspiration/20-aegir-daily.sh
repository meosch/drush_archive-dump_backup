#!/bin/sh

### By H. Kurth Bemis from Proper Aegir backups with Backupninja and duplicity under Debian 7
### https://kurthbemis.com/2015/02/06/proper-aegir-backups-backupninja-duplicity/

when = everyday at 03:30
 
DUPLICITY=/usr/bin/duplicity
BACKUP_DIR="/var/aegir/backups/tmp"
 
DUP_ENCRYPTKEY='CC593F68'
DUP_SIGNKEY='CC593F68'
export PASSPHRASE='<PASSWD>'
export FTP_PASSWORD='<PASSWD>'
 
DUP_FTP_TARGET='ftp://<FTP_USER>@<REMOTE BACKUP SERVER>/daily'
 
SITES=`cat /srv/etc/aegir-backup-sites.txt`
 
umask 007
 
for SITE in $SITES; do
        info "Backing Up $SITE"
 
        rm $BACKUP_DIR/$SITE/*.*
 
        BACKUP_FILE=$SITE-daily-`date +%m-%d-%y`.tar.gz
 
        sudo -u aegir mkdir -p $BACKUP_DIR/$SITE
        sudo -u aegir drush -q @${SITE} archive-backup --overwrite --destination=$BACKUP_DIR/$SITE/$BACKUP_FILE
 
        info "Uploading $SITE ($BACKUP_FILE)"
        $DUPLICITY --encrypt-key $DUP_ENCRYPTKEY --sign-key $DUP_SIGNKEY $BACKUP_DIR/$SITE $DUP_FTP_TARGET/$SITE
 
        info "Cleaning Up"
        rm $BACKUP_DIR/$SITE/*
        $DUPLICITY remove-all-but-n-full 7 --force $DUP_FTP_TARGET/$SITE
done
