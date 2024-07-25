#!/bin/bash

cd /home/cross/synapse

sudo docker compose down

cd /home/cross

sudo RESTIC_PASSWORD=<password> restic -r /home/cross/HDD/restic_synapse backup /home/cross/synapse

cd /home/cross/synapse

sudo docker compose up -d
