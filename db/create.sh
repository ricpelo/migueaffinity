#!/bin/sh

if [ "$1" = "travis" ]; then
    psql -U postgres -c "CREATE DATABASE migueaffinity_test;"
    psql -U postgres -c "CREATE USER migueaffinity PASSWORD 'migueaffinity' SUPERUSER;"
else
    [ "$1" = "test" ] || sudo -u postgres dropdb --if-exists migueaffinity
    sudo -u postgres dropdb --if-exists migueaffinity_test
    [ "$1" = "test" ] || sudo -u postgres dropuser --if-exists migueaffinity
    [ "$1" = "test" ] || sudo -u postgres psql -c "CREATE USER migueaffinity PASSWORD 'migueaffinity' SUPERUSER;"
    [ "$1" = "test" ] || sudo -u postgres createdb -O migueaffinity migueaffinity
    [ "$1" = "test" ] || sudo -u postgres psql -d migueaffinity -c "CREATE EXTENSION pgcrypto;" 2>/dev/null
    sudo -u postgres createdb -O migueaffinity migueaffinity_test
    sudo -u postgres psql -d migueaffinity_test -c "CREATE EXTENSION pgcrypto;" 2>/dev/null
    [ "$1" = "test" ] && exit
    LINE="localhost:5432:*:migueaffinity:migueaffinity"
    FILE=~/.pgpass
    if [ ! -f $FILE ]; then
        touch $FILE
        chmod 600 $FILE
    fi
    if ! grep -qsF "$LINE" $FILE; then
        echo "$LINE" >> $FILE
    fi
fi
