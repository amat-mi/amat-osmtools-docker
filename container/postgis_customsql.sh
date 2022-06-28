#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

DATADIR=${DATADIR:-.}

DB_HOST="${DB_HOST:-host.docker.internal}"
DB_PORT="${DB_PORT:-5432}"

FILENAME=$1
NEED_SUPER=${2:-0}

names=( "DATADIR" )
if [ $NEED_SUPER == 0 ]; then
	names+=( "DB_HOST" "DB_PORT" "DB_USER" "DB_NAME" "DB_PASSWORD" )
else
	names+=( "DB_HOST" "DB_PORT" "SUPER_USER" "DB_NAME" "SUPER_PASSWORD" )
fi
names+=( "FILENAME" "NEED_SUPER" )

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
# Execute custom SQL from specified file"

if [ $NEED_SUPER == 0 ]; then
	export PGPASSWORD=$DB_PASSWORD
	psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d "${DB_NAME}" -f "${DATADIR}/${FILENAME}"
else
	export PGPASSWORD=$SUPER_PASSWORD
	psql -h $DB_HOST -p $DB_PORT -U $SUPER_USER -d "${DB_NAME}" -f "${DATADIR}/${FILENAME}"
fi

RES=$?
if [ $RES -ne 0 ]; then
    echo "Error ($RES)!!! Exit..."
    exit $RES
fi

echo "#############################################################################
# $(date)
# Done"
