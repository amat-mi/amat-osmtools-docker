#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-5432}"

names=()
names+=( "DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "DB_PASSWORD" )

ok=1
for name in "${names[@]}"
do
    if [ ${name} == "DB_PASSWORD" ]; then
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
# Clear existing area data content from PostGIS
# (this may take a few minutes)"

export JAVACMD_OPTIONS="-Xmx2G"

$SCRIPTDIR/osmosis/bin/osmosis \
	--truncate-pgsql host="${DB_HOST}:${DB_PORT}" user="$DB_USER" database="$DB_NAME" password="$DB_PASSWORD"

RES=$?
if [ $RES -ne 0 ]; then
    echo "Error ($RES)!!! Exit..."
    exit $RES
fi

echo "#############################################################################
# $(date)
# Done"
