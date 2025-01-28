#!/bin/bash
set -ex  # Enable verbose logging for debugging

# Log environment variables for debugging
echo "Environment Variables:"
echo "POSTGRES_USER=$POSTGRES_USER"
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD"
echo "POSTGRES_DB=$POSTGRES_DB"

# Define PostgreSQL data directory
export PGDATA=/data/postgres

# Ensure the PostgreSQL data directory exists
mkdir -p "$PGDATA"
chown -R postgres:postgres "$PGDATA"
chmod -R 700 "$PGDATA"



# Configure PostgreSQL
echo "Configuring PostgreSQL..."
echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

# Start PostgreSQL
echo "Starting PostgreSQL..."
sudo -u postgres pg_ctl -D "$PGDATA" -o "-c logging_collector=off -c log_statement=all -c log_destination=stderr" start

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL readiness..."
until sudo -u postgres pg_isready; do
    sleep 1
done

echo "Testing PostgreSQL connection..."
PGPASSWORD=$POSTGRES_PASSWORD psql -h localhost -U $POSTGRES_USER -d $POSTGRES_DB -c "SELECT 1;" || exit 1

# Create database and user if not already present
echo "Creating database and user..."
sudo -u postgres psql <<-EOSQL
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '$POSTGRES_USER') THEN
       CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';
   END IF;
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '$POSTGRES_DB') THEN
       CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;
   END IF;
END
\$\$;
EOSQL

# Start Rails application
echo "Starting Rails application..."
exec /rails/bin/docker-entrypoint "./bin/rails" "server" -e production -b 0.0.0.0 --verbose
