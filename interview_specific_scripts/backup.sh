#!/bin/bash

echo "--- Starting Backup Process ---"

TARGET_DIR="interview_specific_scripts/data"
mkdir -p $TARGET_DIR/

# Ensure docker-compose services are running
if [ ! "$(docker-compose --env-file config.env ps -q postgres)" ] || [ -z "$(docker-compose --env-file config.env ps -q postgres)" ]; then
  echo "Error: The 'postgres' service is not running. Please start it with 'docker-compose up -d'."
  exit 1
fi

# --- Step 1: Backup PostgreSQL Database ---
echo "Backing up PostgreSQL database..."

# Load environment variables from .env file to get credentials
set -o allexport
source config.env
set +o allexport

# Use docker exec to run pg_dump inside the container
docker exec --env-file config.env -t postgres pg_dumpall -c -U "$PG_USER" > $TARGET_DIR/postgres_backup.sql

if [ $? -eq 0 ]; then
  echo "PostgreSQL backup created successfully: $TARGET_DIR/postgres_backup.sql"
else
  echo "Error: PostgreSQL backup failed."
  exit 1
fi

# --- Step 2: Archive MinIO Artifacts ---
echo "Archiving MinIO data directory..."
docker run --rm -v ./data:/data -v $(pwd)/$TARGET_DIR:/backup alpine tar -czvf /backup/minio_data.tar.gz /data

if [ $? -eq 0 ]; then
  echo "MinIO artifacts archived successfully: $TARGET_DIR/minio_data.tar.gz"
else
  echo "Error: MinIO archiving failed."
  exit 1
fi

echo "--- Backup Complete ---"
echo "1. $TARGET_DIR/postgres_backup.sql"
echo "2. $TARGET_DIR/minio_data.tar.gz"