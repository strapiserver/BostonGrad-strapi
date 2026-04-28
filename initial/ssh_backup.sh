
# Server details
SERVER_IP="80.249.149.97"
SSH_USER="root"

# Remote volume name
REMOTE_VOLUME="strapi_strapi-data"
BACKUP_FILENAME="strapi-data-backup-$(date +%Y%m%d%H%M%S).tar.gz"

# Remote and local paths
REMOTE_BACKUP_PATH="/tmp/$BACKUP_FILENAME"
LOCAL_BACKUP_PATH="./$BACKUP_FILENAME"

echo "Connecting to $SERVER_IP..."

# Step 1: Create a backup of the Docker volume on the remote server
ssh "$SSH_USER@$SERVER_IP" << EOF
    echo "Creating backup of Docker volume $REMOTE_VOLUME..."
    docker run --rm \
        -v $REMOTE_VOLUME:/volume \
        -v /tmp:/backup \
        alpine:latest \
        sh -c "tar czf /backup/$BACKUP_FILENAME -C /volume ."
EOF

# Step 2: Transfer the backup file to the local machine
echo "Transferring the backup file to local machine..."
scp "$SSH_USER@$SERVER_IP:$REMOTE_BACKUP_PATH" "$LOCAL_BACKUP_PATH"

# Step 3: Clean up the backup file on the remote server
ssh "$SSH_USER@$SERVER_IP" "rm -f $REMOTE_BACKUP_PATH"

echo "Backup complete! File saved to $LOCAL_BACKUP_PATH."
