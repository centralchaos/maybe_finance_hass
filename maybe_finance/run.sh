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
DB_HOST=$(jq --raw-output '.db_host // "172.30.32.1"' "$CONFIG_PATH")
DB_PORT=$(jq --raw-output '.db_port // "5432"' "$CONFIG_PATH")
POSTGRES_USER=$(jq --raw-output '.postgres_user // "postgres"' "$CONFIG_PATH")
APP_DOMAIN=$(jq --raw-output '.app_domain // "http://localhost"' "$CONFIG_PATH")
PLAID_CLIENT_ID=$(jq --raw-output '.plaid_client_id // empty' "$CONFIG_PATH")
PLAID_SECRET=$(jq --raw-output '.plaid_secret // empty' "$CONFIG_PATH")
PLAID_ENV=$(jq --raw-output '.plaid_env // empty' "$CONFIG_PATH")

echo "DEBUG: Configured values:"
echo "POSTGRES_PASSWORD: HIDDEN"
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "POSTGRES_USER: $POSTGRES_USER"
echo "APP_DOMAIN: $APP_DOMAIN"

# Export as environment variables
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
export SECRET_KEY_BASE="${SECRET_KEY_BASE}"
export DB_HOST="${DB_HOST}"
export DB_PORT="${DB_PORT}"
export POSTGRES_USER="${POSTGRES_USER}"
export APP_DOMAIN="${APP_DOMAIN}"
export SELF_HOSTED="true"
export DISABLE_SSL="false"
export HOSTING_PLATFORM="localhost"

# Export optional Plaid configuration if set
[ -n "$PLAID_CLIENT_ID" ] && export PLAID_CLIENT_ID="${PLAID_CLIENT_ID}"
[ -n "$PLAID_SECRET" ] && export PLAID_SECRET="${PLAID_SECRET}"
[ -n "$PLAID_ENV" ] && export PLAID_ENV="${PLAID_ENV}"

# Start the Rails server
exec ./bin/rails server
