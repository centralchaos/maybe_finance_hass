#!/bin/bash
set -e

# Get environment variables from Home Assistant
export POSTGRES_USER=${POSTGRES_USER:-maybe_user}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-maybe_password}
export POSTGRES_DB=${POSTGRES_DB:-maybe_db}
export PGDATA=/data/postgres

# Create and configure PostgreSQL directory
if [ ! -d "$PGDATA" ]; then
    sudo mkdir -p "$PGDATA"
    sudo chown postgres:postgres "$PGDATA"
    sudo -u postgres initdb \
        --username="$POSTGRES_USER" \
        --pwfile=<(echo "$POSTGRES_PASSWORD")

    # Configure PostgreSQL
    echo "host all all 0.0.0.0/0 md5" | sudo tee -a "$PGDATA/pg_hba.conf"
    echo "listen_addresses = '*'" | sudo tee -a "$PGDATA/postgresql.conf"
fi

# Start PostgreSQL
sudo -u postgres pg_ctl -D "$PGDATA" -l /var/log/postgres.log start

# Wait for PostgreSQL readiness
until sudo -u postgres pg_isready; do
    sleep 1
done

# Create database and user (idempotent)
sudo -u postgres psql -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';" || true
sudo -u postgres psql -c "CREATE DATABASE $POSTGRES_DB WITH OWNER $POSTGRES_USER;" || true

# Start Maybe Finance using original entrypoint
exec /rails/bin/docker-entrypoint "./bin/rails" "server"