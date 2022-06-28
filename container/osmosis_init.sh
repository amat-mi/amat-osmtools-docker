#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

SCRIPTDIR=${SCRIPTDIR:-.}

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-5432}"

names=( "SCRIPTDIR" )
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
# Init database if it is not yet"

export PGPASSWORD=$DB_PASSWORD

ok=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -tc "SELECT 1 FROM pg_tables WHERE schemaname='public' and tablename='ways'")

ok=${ok:-0}
if [ $ok == 1 ]; then
	echo "# Database already initialized \"${DB_NAME}\""
else
	echo "Initializing"
	DIR_OSMOSIS=$SCRIPTDIR/osmosis/script
	psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -f "${DIR_OSMOSIS}/pgsnapshot_schema_0.6.sql"
	psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -f "${DIR_OSMOSIS}/pgsnapshot_schema_0.6_action.sql"
	psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -f "${DIR_OSMOSIS}/pgsnapshot_schema_0.6_bbox.sql"
	psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -f "${DIR_OSMOSIS}/pgsnapshot_schema_0.6_changes.sql"
	psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -f "${DIR_OSMOSIS}/pgsnapshot_schema_0.6_linestring.sql"
fi

RES=$?
if [ $RES -ne 0 ]; then
    echo "Error ($RES)!!! Exit..."
    exit $RES
fi

echo "#############################################################################
# $(date)
# Done"
