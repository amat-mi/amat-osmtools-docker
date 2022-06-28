#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

SCRIPTDIR=${SCRIPTDIR:-.}
DATADIR=${DATADIR:-.}

names=( "DATADIR" )
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
# $(date)"

FILELAST="${DATADIR}/${AREA_NAME}-latest.osm.pbf"

mkdir -p $DATADIR

# remove file, ignoring if it didn't exist
rm -f ${FILELAST}

echo "#############################################################################
# $(date)
# Done"
