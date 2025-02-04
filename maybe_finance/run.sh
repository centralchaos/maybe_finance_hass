#!/usr/bin/env bash
CONFIG_PATH="/data/options.json"

# Ensure the file exists
if [ ! -f "$CONFIG_PATH" ]; then
    echo "Config file not found: $CONFIG_PATH"
    exit 1
fi

# Read user-configured values
POSTGRES_PASSWORD=$(jq --raw-output '.postgres_password' "$CONFIG_PATH")
SECRET_KEY_BASE=$(jq --raw-output '.secret_key_base' "$CONFIG_PATH")

echo "M123"
echo "POSTGRES_PASSWORD: $POSTGRES_PASSWORD"

# Export as environment variables
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
export SECRET_KEY_BASE="${SECRET_KEY_BASE}"
export DB_HOST="172.30.32.1"
export DB_PORT="5432"
export POSTGRES_USER="postgres"
export SELF_HOSTED="true"
export DISABLE_SSL="false"
export HOSTING_PLATFORM="localhost"

# Start the Rails server
exec ./bin/rails server
