#!/bin/bash

BACKUP_DIR=./strapi_backups
VOLUME_NAME=strapi4_data

# Pull the alpine image if it's not already available
docker pull alpine > /dev/null

# Find the most recent backup file
LATEST_BACKUP=$(ls -t "$BACKUP_DIR" | head -n 1)

if [ -n "$LATEST_BACKUP" ]; then

    if docker run --rm \
        -v ${VOLUME_NAME}:/volume \
        -v ${BACKUP_DIR}:/backup \
        alpine \
        sh -c "tar -xzf /backup/$LATEST_BACKUP -C /volume"; then
        echo "[$(date)] Restored from $LATEST_BACKUP"
    else
        echo "[$(date)] Restore failed for $LATEST_BACKUP" >&2
    fi

else
    echo "No backup files found in $BACKUP_DIR."
fi
