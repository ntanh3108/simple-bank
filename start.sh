#!/bin/sh

set -e

echo "run db migration"
set -a
source /app/app.env
set +a
/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
