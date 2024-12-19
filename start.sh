#!/bin/sh
set -e

echo "run db migration"

# Tự động export mọi biến sau khi đọc file .env
set -a
. /app/app.env
set +a

# Kiểm tra xem biến đã được load chưa
echo "DB_SOURCE=$DB_SOURCE"

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
