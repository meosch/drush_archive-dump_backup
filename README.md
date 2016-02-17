# Drush archive-dump Backup
A script to be called by cron to automate backups of Drupal sites via the [Drush archive-dump(aliases ard, archive-backup, arb) command](http://drushcommands.com/drush-7x/core/archive-dump/).

**Currently this is a work in progress. Use this project at your own risk.**

## Planned for inclusion in this project
1. Backup script to be run by cron.
2. Backup archive made by Drush archive-dump command.
3. Reuse configuration in Drush aliases for configuration.
4. Separate configuration file.
5. Transfer to remote backup location via scp.
6. Logging
7. Notifications via email and Pushbullet.
8. Backup file management - What backups are kept and how long.
9. Configuration in configuration file can be overridden on the command line with options.
