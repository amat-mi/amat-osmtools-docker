#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-5432}"

names=()
names+=( "DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "DB_PASSWORD" "SUPER_USER" "SUPER_PASSWORD" )

ok=1
for name in "${names[@]}"
do
    if [ ${name} == "DB_PASSWORD" ] || [ ${name} == "SUPER_PASSWORD" ]; then
	    echo "${name} => ***************"
    else
    	echo "${name} => ${!name}"
    fi

    if [ -z "${!name}" ]; then
        echo "   MISSING"
        ok=0
    fi
done

if [ $ok == 0 ]; then
	echo "Exit"
	exit 999
fi

echo "#############################################################################
# $(date)
# Create database if it doesn't yet exist"

export PGPASSWORD=$SUPER_PASSWORD

ok=$(psql -h $DB_HOST -p $DB_PORT -U $SUPER_USER -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'")

ok=${ok:-0}
if [ $ok == 1 ]; then
	echo "# Database already present \"${DB_NAME}\""
else
	echo "Creating"
	cat <<End-Of-Session | psql -h $DB_HOST -p $DB_PORT -U $SUPER_USER -d postgres
CREATE DATABASE "${DB_NAME}"
    WITH 
    OWNER = $DB_USER
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
\c $DB_NAME
CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
\q
End-Of-Session
fi

RES=$?
if [ $RES -ne 0 ]; then
    echo "Error ($RES)!!! Exit..."
    exit $RES
fi

echo "#############################################################################
# $(date)
# Done"
