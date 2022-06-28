#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

DATADIR=${DATADIR:-.}

OSMUPDATE_WHAT=${OSMUPDATE_WHAT:-AREA}

names=( "DATADIR" )
names+=( "BASEOSM_URL" "BASEOSM_NAME" )
names+=( "OSMUPDATE_WHAT" )

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

DIR_OSMUPDATE=$SCRIPTDIR/osmupdate

BASEOSM_FILE="${DATADIR}/${BASEOSM_NAME}"

mkdir -p $DATADIR

# if file missing or older than 3 days, download it anew
ok=1
if [ ! -f ${BASEOSM_FILE} ]; then
    ok=0
elif [ `stat --format=%Y ${BASEOSM_FILE}` -le $(( `date +%s` - 3 * 24 * 60 * 60 )) ]; then
	ok=0
fi

if [ $ok == 1 ]; then
	echo "# Initial data from OSM already present ${BASEOSM_FILE}"
else
echo "# Download initial data from OSM to ${BASEOSM_FILE}
# (this may take a few minutes)"

	wget --quiet -P $DATADIR -O $BASEOSM_FILE $BASEOSM_URL

	RES=$?
	if [ $RES -ne 0 ]; then
	    echo "Error: ($RES)!!! Exit..."
	    exit $RES
	fi
fi

if [ ${OSMUPDATE_WHAT} == "BASE" ]; then
echo "#############################################################################
# $(date)
# Update base file
# (this may take a few minutes)"

	# MUST go into its osmupdate directory, or it won't work!!!
	cd $DIR_OSMUPDATE

	TMP_BASEOSM_FILE="${DATADIR}/tmp-${BASEOSM_NAME}"

	./osmupdate ${BASEOSM_FILE} ${TMP_BASEOSM_FILE}

	RES=$?
	if [ $RES -eq 21 ]; then				#in case no data changes present
		echo $RES
	else
		if [ $RES -ne 0 ]; then
			echo "Error ($RES)!!! Exit..."
			exit $RES
		fi
	fi

	mv ${TMP_BASEOSM_FILE} ${BASEOSM_FILE}
fi

echo "#############################################################################
# $(date)
# Done"
