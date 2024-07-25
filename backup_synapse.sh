#!/bin/bash

# Set backup directory to a directory outside of the Synapse dir
BACKUP_DIR="/home/cross/HDD/synapse_backups"

# Create backup directory if it doesn't exist
sudo mkdir -p "$BACKUP_DIR"

# Get current date and time
DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Check if Synapse stack is running
if ! docker compose -f /home/cross/synapse/docker-compose.yml ps | grep -q "Up"; then
  echo "Synapse stack is not running. Skipping backup."
  exit 1
fi

# Create a snapshot of the storage directory using rsync
sudo rsync -a --delete --link-dest=/home/cross/synapse/storage /home/cross/synapse/storage/ /home/cross/synapse/storage.snapshot/

# Database backups
sudo docker exec -t maindb pg_dump -U postgres -c -C synapse > /home/cross/synapse/maindb_backup.sql &
sudo docker exec -t syncdb pg_dump -U postgres -c -C syncv3 > /home/cross/synapse/syncdb_backup.sql &

# Wait for all background jobs to complete
wait

# Combine backups and save as a dated.tgz file in the backup directory
sudo tar -czvpf "$BACKUP_DIR/synapse_backup_$DATE.tgz" \
    /home/cross/synapse/data \
    /home/cross/synapse/maindb_backup.sql \
    /home/cross/synapse/syncdb_backup.sql \
    /home/cross/synapse/docker-compose.yml \
    /home/cross/synapse/storage.snapshot/

# Cleanup leftover.sql files and snapshot directory
sudo rm /home/cross/synapse/*.sql
sudo rm -rf /home/cross/synapse/storage.snapshot/
