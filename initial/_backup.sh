#!/bin/bash

# Server Details
SERVER_IP="80.249.149.97"
SSH_USER="root"
BACKUP_DIR="./backups"
REMOTE_BACKUP_DIR="/tmp"

# Declare volumes to back up (based on your docker-compose file)
declare -a VOLUMES=("strapi_strapi-data" "config" "npm-data" "npm-letsencrypt" "nginx-html")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Function to back up all volumes
backup_volumes() {
    echo "Backing up volumes: ${VOLUMES[*]}"
    for VOLUME in "${VOLUMES[@]}"; do
        BACKUP_FILE="$BACKUP_DIR/${VOLUME}-backup-$(date +%Y%m%d%H%M%S).tar.gz"
        echo "Backing up volume: $VOLUME"

        ssh "$SSH_USER@$SERVER_IP" << EOF
            docker run --rm \
                -v $VOLUME:/volume \
                -v $REMOTE_BACKUP_DIR:/backup \
                alpine:latest \
                sh -c "tar czf /backup/${VOLUME}-backup.tar.gz -C /volume ."
EOF

        if scp "$SSH_USER@$SERVER_IP:$REMOTE_BACKUP_DIR/${VOLUME}-backup.tar.gz" "$BACKUP_FILE"; then
            ssh "$SSH_USER@$SERVER_IP" "rm -f $REMOTE_BACKUP_DIR/${VOLUME}-backup.tar.gz"
            echo "Backup of $VOLUME succeeded! Saved to $BACKUP_FILE"
        else
            echo "Backup of $VOLUME failed."
        fi
    done
}

# Function to restore all volumes
restore_volumes() {
    echo "Restoring volumes: ${VOLUMES[*]}"
    
    # Stop dependent containers once before restoring volumes
    echo "Stopping containers for volumes: ${VOLUMES[*]}"
    ssh "$SSH_USER@$SERVER_IP" << EOF
        docker-compose -f ./docker-compose.yml stop
EOF

    # Iterate over each volume and restore
    for VOLUME in "${VOLUMES[@]}"; do
        LATEST_BACKUP=$(ls -t $BACKUP_DIR/${VOLUME}-backup-*.tar.gz | head -n 1)
        if [[ -z "$LATEST_BACKUP" ]]; then
            echo "No backup found for $VOLUME. Skipping..."
            continue
        fi

        echo "Restoring volume: $VOLUME from $LATEST_BACKUP"

        scp "$LATEST_BACKUP" "$SSH_USER@$SERVER_IP:$REMOTE_BACKUP_DIR/"
        
        # Check if the backup file exists on the remote server
        ssh "$SSH_USER@$SERVER_IP" "ls -l $REMOTE_BACKUP_DIR/$(basename $LATEST_BACKUP)"
        
        # Restore the volume using the backup
        ssh "$SSH_USER@$SERVER_IP" << EOF
            docker run --rm \
                -v $VOLUME:/volume \
                -v $REMOTE_BACKUP_DIR:/backup \
                alpine:latest \
                sh -c "tar xzf /backup/$(basename $LATEST_BACKUP) -C /volume"
            rm -f $REMOTE_BACKUP_DIR/$(basename $LATEST_BACKUP)
            echo "Restored volume: $VOLUME"
EOF
    done

    # Start containers once all volumes are restored
    echo "Starting containers after restoring all volumes"
    ssh "$SSH_USER@$SERVER_IP" << EOF
        docker-compose -f ./docker-compose.yml start
EOF

    echo "Restore completed!"
}

# Main Menu
echo "Docker Volume Backup and Restore"
PS3="Please select an option: "
options=("Back Up All Volumes" "Restore All Volumes" "Exit")
select opt in "${options[@]}"; do
    case $opt in
        "Back Up All Volumes")
            backup_volumes
            break
            ;;
        "Restore All Volumes")
            restore_volumes
            break
            ;;
        "Exit")
            echo "Exiting script."
            break
            ;;
        *)
            echo "Invalid option. Try again."
            ;;
    esac
done