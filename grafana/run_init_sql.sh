#!/bin/bash
set -e

# Wait for PostgreSQL to accept connections
until pg_isready -h "${DATABASE_HOST:?}" -p "${DATABASE_PORT:-5432}" -U "${DATABASE_USER:?}"; do
	echo "Waiting for PostgreSQL to start..."
	sleep 2
done

# Create the GCJ-02 conversion functions (idempotent)
PGPASSWORD="${DATABASE_PASS:?}" psql -v ON_ERROR_STOP=1 \
	-h "${DATABASE_HOST:?}" -p "${DATABASE_PORT:-5432}" -U "${DATABASE_USER:?}" \
	-d "${DATABASE_NAME:-teslamate}" -f /proc.sql

exec /run.sh "$@"
