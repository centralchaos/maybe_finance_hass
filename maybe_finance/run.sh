#!/bin/bash

# Read environment variables from Home Assistant options
export POSTGRES_USER=${POSTGRES_USER:-maybe_user}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-maybe_password}
export POSTGRES_DB=${POSTGRES_DB:-maybe_db}
export PGDATA=/data/postgres

# Initialize PostgreSQL if not exists
if [ ! -d "$PGDATA" ]; then
    echo "Initializing PostgreSQL database..."
    mkdir -p "$PGDATA"
    chown -R postgres:postgres "$PGDATA"
    su postgres -c "initdb --username=$POSTGRES_USER --pwfile=<(echo \"$POSTGRES_PASSWORD\")"

    # Configure PostgreSQL
    echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
    echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"
fi

# Start PostgreSQL
echo "Starting PostgreSQL..."
service postgresql start

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to become ready..."
until su postgres -c "pg_isready"; do
    sleep 1
done

# Create database and user (if not exists)
echo "Creating database and user..."
su postgres -c "psql -c \"CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';\"" || true
su postgres -c "psql -c \"CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER;\"" || true

# Start Maybe Finance (using original image's entrypoint)
echo "Starting Maybe Finance..."
exec /app/run.sh  # Replace with actual command from base image