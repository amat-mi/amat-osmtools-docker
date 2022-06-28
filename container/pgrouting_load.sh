#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

SCRIPTDIR=${SCRIPTDIR:-.}
DATADIR=${DATADIR:-.}

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-5432}"

PGROUTING_TRANSMODE="${PGROUTING_TRANSMODE:-$1}"
PGROUTING_CONF="${PGROUTING_CONF:-mapconfig_${PGROUTING_TRANSMODE}.xml}"
PGROUTING_PREFIX="${PGROUTING_PREFIX:-${PGROUTING_TRANSMODE}_}"

names=( "SCRIPTDIR" "DATADIR" )
names+=( "DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "DB_PASSWORD" )
names+=( "AREA_NAME" )
names+=( "PGROUTING_TRANSMODE" "PGROUTING_CONF" "PGROUTING_PREFIX")

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
# Convert area file data into plain format"

DIR_OSMUPDATE=$SCRIPTDIR/osmupdate

FILELAST="${DATADIR}/${AREA_NAME}-latest.osm.pbf"
FILEOSM="${DATADIR}/${AREA_NAME}-latest.osm"

# MUST go into its osmupdate directory, or it won't work!!!
cd $DIR_OSMUPDATE

./osmconvert ${FILELAST} --drop-author --drop-version --out-osm -o=${FILEOSM}

echo "#############################################################################
# $(date)
# Load area file data into PostGIS, replacing existing content (pgRouting format)
# (this may take a few minutes)"

FILECONF="${DATADIR}/${PGROUTING_CONF}"

osm2pgrouting \
    --f ${FILEOSM} \
    --conf ${FILECONF} \
    --dbname ${DB_NAME} \
    --username ${DB_USER} \
    --password ${DB_PASSWORD} \
    --host ${DB_HOST} \
    --port ${DB_PORT} \
    --prefix ${PGROUTING_PREFIX} \
    --clean

RES=$?
if [ $RES -ne 0 ]; then
    echo "Error ($RES)!!! Exit..."
    exit $RES
fi

echo "#############################################################################
# $(date)
# Done"
