#!/bin/bash

BACKUP_DIR="/home/cross/HDD/synapse_backups"

sudo mkdir -p "$BACKUP_DIR"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

cd /home/cross/synapse

sudo docker compose down

cd /home/cross

sudo tar -czvpf "$BACKUP_DIR/synapse_backup_$DATE.tgz" /home/cross/synapse

cd /home/cross/synapse

sudo docker compose up -d

# Clean up old backups, keeping only the last 3 days
sudo find "$BACKUP_DIR" -type f -name "synapse_backup_*.tgz" -mtime +3 -exec rm -f {} \;
