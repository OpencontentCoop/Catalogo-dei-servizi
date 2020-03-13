#!/bin/bash
set -e
# CREATE DATABASE [IF NOT EXISTS] db_name;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE ROLE postgres LOGIN PASSWORD 'openp4assword';
EOSQL

exit 0
