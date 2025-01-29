#!/bin/sh

# Load environment variables with fallbacks
export DB_HOST="${DB_HOST}"
export DB_PORT="${DB_PORT}"
export POSTGRES_USER="${POSTGRES_USER}"
export POSTGRES_PASSWORD="${POSTGRES_PASSWORD}"
export SECRET_KEY_BASE="${SECRET_KEY_BASE}"

echo "Using Database: $DB_HOST:$DB_PORT - User: $POSTGRES_USER"

# Start Maybe Finance
exec ./bin/rails server