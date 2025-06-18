#!/bin/bash

echo "--- Starting Restore Process ---"

TARGET_DIR="interview_specific_scripts/data"

# Ensure required files exist
if [ ! -f "$TARGET_DIR/postgres_backup.sql" ] || [ ! -f "$TARGET_DIR/minio_data.tar.gz" ]; then
  echo "Error: Backup files '$TARGET_DIR/postgres_backup.sql' and/or '$TARGET_DIR/minio_data.tar.gz' not found."
  exit 1
fi

# Ensure docker-compose services are running
if [ ! "$(docker-compose --env-file config.env ps -q postgres)" ] || [ -z "$(docker-compose --env-file config.env ps -q postgres)" ]; then
  echo "Error: The 'postgres' service is not running. Please start it with 'docker-compose up -d'."
  exit 1
fi

# Restore MinIO Artifacts
echo "Extracting MinIO data directory..."
tar -xzvf $TARGET_DIR/minio_data.tar.gz

if [ $? -eq 0 ]; then
  echo "MinIO artifacts restored successfully."
else
  echo "Error: MinIO restore failed."
  exit 1
fi

# Restore PostgreSQL Database
echo "Restoring PostgreSQL database..."

# Load environment variables from .env file to get credentials
set -o allexport
source config.env
set +o allexport

POSTGRES_CONTAINER_ID=$(docker-compose --env-file config.env ps -q postgres)

echo "Dropping and recreating the '$PG_DB' database..."
docker exec -i $POSTGRES_CONTAINER_ID psql -U "$PG_USER" -d postgres <<EOF
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '$PG_DB' AND pid <> pg_backend_pid();

-- Now, drop and create the database
DROP DATABASE IF EXISTS $PG_DB;
CREATE DATABASE $PG_DB;
PG_CMDS
EOF

# Use docker exec to run psql and restore the dump
cat $TARGET_DIR/postgres_backup.sql | docker exec --env-file config.env -i postgres psql -U "$PG_USER" -d "$PG_DB"

if [ $? -eq 0 ]; then
  echo "PostgreSQL database restored successfully."
else
  echo "Error: PostgreSQL restore failed."
  exit 1
fi

echo "--- Restore Complete ---"