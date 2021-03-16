#!/bin/sh

BASE_DIR=$(dirname "$(readlink -f "$0")")
if [ "$1" != "test" ]; then
    psql -h localhost -U migueaffinity -d migueaffinity < $BASE_DIR/migueaffinity.sql
    if [ -f "$BASE_DIR/migueaffinity_test.sql" ]; then
        psql -h localhost -U migueaffinity -d migueaffinity < $BASE_DIR/migueaffinity_test.sql
    fi
    echo "DROP TABLE IF EXISTS migration CASCADE;" | psql -h localhost -U migueaffinity -d migueaffinity
fi
psql -h localhost -U migueaffinity -d migueaffinity_test < $BASE_DIR/migueaffinity.sql
echo "DROP TABLE IF EXISTS migration CASCADE;" | psql -h localhost -U migueaffinity -d migueaffinity_test
