#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

DATADIR=${DATADIR:-.}

names=( "DATADIR" )
names+=( "BASEOSM_URL" "BASEOSM_NAME" )

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

BASEOSM_FILE="${DATADIR}/${BASEOSM_NAME}"

mkdir -p $DATADIR

# remove file, ignoring if it didn't exist
rm -f ${BASEOSM_FILE}

echo "#############################################################################
# $(date)
# Done"
