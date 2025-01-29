#!/bin/bash

# Database connection variables
DB_HOST="addon_postgres"
DB_PORT=5432
DB_USER="postgres"
DB_PASSWORD="homeassistant"
DB_NAME="maybe_finance_db"

# Create database if not exists
echo "Checking if database '${DB_NAME}' exists..."
DB_EXISTS=$(PGPASSWORD=${DB_PASSWORD} psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'")

if [ "${DB_EXISTS}" = "1" ]; then
  echo "Database '${DB_NAME}' already exists. Skipping creation."
else
  echo "Creating database '${DB_NAME}'... on host ${DB_HOST}"
  PGPASSWORD=${DB_PASSWORD} psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -d postgres -c "CREATE DATABASE ${DB_NAME};"
  echo "Database '${DB_NAME}' created successfully."
fi
