# YouPin Backupper
Backup scripts for YouPin

# Requirements
1. Make sure you have Google Cloud SDK (gcloud, gsutil commands) and mongodump on your server.
2. Generate service account to grant your server permission to access your storage bucket. Also make sure you grant this service account as a storage admin. So this account can read/write to this storage bucket.
By generating the service account, you should get a .json key file which we will use to authenticate our script to access the storage.

# Script Usage
```
./start-gcs-backup.sh <keyfile.json> <db-name-in-mongo> <bucket-name-in-gcs>
```

# Step-by-step to setup cronjob
1. Move the secret key file to your server.
2. Clone this repo onto your server.
3. Run `crontab -e` to set cronjob. Add the script with the correct parameters. For example,
```
0 0 * * * /bin/bash /opt/youpin-backupper/start-gcs-backup.sh key_file.json youpin youpin_backup_bucket
```
