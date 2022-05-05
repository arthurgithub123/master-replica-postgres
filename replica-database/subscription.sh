#!/bin/bash

# exit immediately if a command exits with a non-zero status
# set -e

# Wait for master database to start
pg_isready --host=master_database --port=5432
while [ $? != 0 ]; do
  sleep 1
  pg_isready --host=master_database --port=5432
done

# Wait master database start listening in its TCP Socket
../wait-for-it.sh master_database:5432 --strict --timeout=0 --

# Wait for replica database to start. If wait-for-it.sh
# does not wait, an error will be thrown:
# FATAL:  the database system is starting up
# psql: error: connection to server at "replica_database",
# port 5432 failed: FATAL: the database  system is starting up.
# (Try removing lines 12 to 16 below and see what happens).
# https://www.postgresql.org/docs/current/app-pg-isready.html
pg_isready --host=replica_database --port=5432
while [ $? != 0 ]; do
  sleep 1
  pg_isready --host=replica_database --port=5432
done

# Waits for replica TCP Socket listening before
# creating table and subscribing to master
../wait-for-it.sh replica_database:5432 --strict --timeout=0 --

psql -v ON_ERROR_STOP=1 -h replica_database -p 5432 --username postgres --dbname shop <<-EOSQL
  CREATE TABLE products (
    id serial PRIMARY KEY,
    name VARCHAR (50) NOT NULL
  );

  CREATE EXTENSION pglogical;

  SELECT pglogical.create_node(
    'read_node',
    'host=replica_database port=5432 dbname=shop user=postgres password=1234'
  );

  SELECT pglogical.create_subscription(
    'read_subscription',
    'host=master_database port=5432 dbname=shop user=postgres password=1234',
    ARRAY['read_replication_set'],
    false,
    true,
    '{}'
  );
EOSQL
