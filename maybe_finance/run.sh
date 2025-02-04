#!/usr/bin/env bash
CONFIG_PATH=/data/options.json

# Read the user-configured values from Home Assistant's UI
POSTGRES_PASSWORD=$(jq --raw-output '.postgres_password' "$CONFIG_PATH")
SECRET_KEY_BASE=$(jq --raw-output '.secret_key_base' "$CONFIG_PATH")

# Set the environment variables
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
export SECRET_KEY_BASE="${SECRET_KEY_BASE}"
export DB_HOST="172.30.32.1"
export DB_PORT="5432"
export POSTGRES_USER="postgres"
export SELF_HOSTED="true"
export DISABLE_SSL="false"
export HOSTING_PLATFORM="localhost"

# Start the Rails server
#exec ./bin/rails server
# Execute the original entrypoint and default command
exec /rails/bin/docker-entrypoint ./bin/rails server