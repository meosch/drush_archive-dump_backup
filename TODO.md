# Drush archive-dump Backup TODO list
1. If the Drush uri starts with **http://** or **https://**, strip it from url of Drush site alias and add warning that this is not the correct format for the uri in a Drush site alias. This ends up creating a file called **http://** which is then not what Drush tries to zip, so the backup fails.
1. Add check to see if any files are still in the temporary backup directory. This is to warn if files are hanging around after failed / aborted backups.
1. Add instructions on how to setup passwordless logins including ssh-keygen and  ssh-copy-id commands.
2. Add instructions on how to setup scponly login on backup server.
3. Add instructions on setting up Drush alias files.
4. Research Drush archive-dump options such as --description --tags and learn more about the MANIFEST.ini
5. Add documentation stating where the database dump and MANIFEST.ini can be found in the archive.
6. Add exit status checking and logic.
7. Should we add looping to backup multiple sites?
8. Add sub-folder options
