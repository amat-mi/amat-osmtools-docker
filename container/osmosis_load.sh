#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

SCRIPTDIR=${SCRIPTDIR:-.}
DATADIR=${DATADIR:-.}

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-5432}"

names=( "SCRIPTDIR" "DATADIR" )
names+=( "DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "DB_PASSWORD" )
names+=( "AREA_NAME" )

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
# Load area file data into PostGIS, replacing existing content (osmosis format)
# (THIS WILL TAKE SEVERAL MINUTES, even 20 or more)"

FILELAST="${DATADIR}/${AREA_NAME}-latest.osm.pbf"

export JAVACMD_OPTIONS="-Xmx2G -Djava.io.tmpdir=${DATADIR}"

$SCRIPTDIR/osmosis/bin/osmosis \
	--truncate-pgsql host="${DB_HOST}:${DB_PORT}" user="$DB_USER" database="$DB_NAME" password="$DB_PASSWORD"

$SCRIPTDIR/osmosis/bin/osmosis \
	--read-pbf file="${FILELAST}" \
	--write-pgsql host="${DB_HOST}:${DB_PORT}" user="$DB_USER" database="$DB_NAME" password="$DB_PASSWORD"

RES=$?
if [ $RES -ne 0 ]; then
    echo "Error ($RES)!!! Exit..."
    exit $RES
fi

echo "#############################################################################
# $(date)
# Done"
