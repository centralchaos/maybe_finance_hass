#!/bin/bash
set -ex

# Log start of script
echo "Starting Maybe Finance Add-on..."

# Check if the environment variables are correctly set
echo "Environment Variables:"
echo "POSTGRES_USER=$POSTGRES_USER"
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD"
echo "POSTGRES_DB=$POSTGRES_DB"


export PGDATA=/data/postgres


# Initialize PostgreSQL directory if necessary
if [ ! -d "$PGDATA" ]; then
    echo "Initializing PostgreSQL data directory..."
    mkdir -p "$PGDATA"
    chown postgres:postgres "$PGDATA"
    chmod 700 "$PGDATA"
    sudo -u postgres initdb --pgdata="$PGDATA"
fi

# Configure PostgreSQL
echo "Configuring PostgreSQL..."
echo "host all all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

# Start PostgreSQL
echo "Starting PostgreSQL..."
sudo -u postgres pg_ctl -D "$PGDATA" -l /var/log/postgres.log start || exit 1

# Wait for PostgreSQL readiness
echo "Waiting for PostgreSQL readiness..."
until sudo -u postgres pg_isready; do
    sleep 1
done

# Create database and user
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




# Start the Rails application
echo "Starting Rails application..."
exec /rails/bin/docker-entrypoint "./bin/rails" "server"
