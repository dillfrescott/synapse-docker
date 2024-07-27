#!/bin/bash

BACKUP_DIR="/home/cross/HDD/synapse_backups"

# Check if the HDD is mounted
if ! mountpoint -q /home/cross/HDD; then
  echo "Error: /home/cross/HDD is not mounted. Exiting."
  exit 1
fi

sudo mkdir -p "$BACKUP_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

cd /home/cross/synapse

sudo docker compose down

cd /home/cross

sudo tar -czvpf "$BACKUP_DIR/synapse_backup_$DATE.tgz" /home/cross/synapse

cd /home/cross/synapse

sudo docker compose up -d

sudo find "$BACKUP_DIR" -type f -name "synapse_backup_*.tgz" -mtime +2 -exec rm -f {} \;
