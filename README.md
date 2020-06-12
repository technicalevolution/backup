# backup
backup / restore scripts

Current thinking

backup.sh will:
-create local copies of backups, that are incremental on a daily basis, with a full backup being done every month
-i dont do a lot of work, so this should be ok
- they will be encrupted using GPG and the private key will be stored offline.
- 3 backups will be kept locally, for some ability to restore without an internet connection

sync.sh will sync the local backups to a remote endpiont, currently testing aws s3, but could be just another server.
sync will get kicked off with systemd-timers, seems to be replcing cron slowly, might be good to learn more.

restore.sh will not be able to access the backups directory from online locations, they will have to be downloaded and decrypted manually.
This should make it hard for anyone to stumble accross the encrypted backups.
