#!/bin/bash
set -ex

# Load environment variables from Home Assistant options
export POSTGRES_USER=${POSTGRES_USER:-maybe_user}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-maybe_password}
export POSTGRES_DB=${POSTGRES_DB:-maybe_db}
export PGDATA=/data/postgres

# Ensure the PostgreSQL data directory exists
if [ ! -d "$PGDATA" ]; then
    mkdir -p "$PGDATA"
    chown postgres:postgres "$PGDATA"
    chmod 700 "$PGDATA"
    sudo -u postgres initdb --pgdata="$PGDATA"
fi

# Configure PostgreSQL
echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

# Start PostgreSQL
sudo -u postgres pg_ctl -D "$PGDATA" -l /var/log/postgres.log start

# Wait for PostgreSQL readiness
until sudo -u postgres pg_isready; do
    sleep 1
done

# Create the database and user if not already present
sudo -u postgres psql <<-EOSQL
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '$POSTGRES_USER') THEN
       CREATE USER $POSTGRES_USER WITH PASSWORD '$
