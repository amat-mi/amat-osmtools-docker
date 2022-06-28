#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

SCRIPTDIR=${SCRIPTDIR:-.}
DATADIR=${DATADIR:-.}

OSMUPDATE_WHAT=${OSMUPDATE_WHAT:-AREA}
OSMCUT=${OSMCUT:-CUT}

names=( "SCRIPTDIR" "DATADIR" )
names+=( "BASEOSM_NAME" )
names+=( "AREA_NAME" "AREA_BOUNDS" )
names+=( "OSMUPDATE_WHAT" "OSMCUT" )

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

FILELAST="${DATADIR}/${AREA_NAME}-latest.osm.pbf"
FILENOW="${DATADIR}/${AREA_NAME}-now.osm.pbf"

mkdir -p $DATADIR

# if area file missing or older than 3 days, get base file and cut it out from that
ok=1
if [ ! -f ${FILELAST} ]; then
    ok=0
elif [ `stat --format=%Y ${FILELAST}` -le $(( `date +%s` - 3 * 24 * 60 * 60 )) ]; then
	ok=0
fi

# MUST go into its osmupdate directory, or it won't work!!!
cd $DIR_OSMUPDATE

# if requested to update base file, must always call base script
if [ ${OSMUPDATE_WHAT} == "BASE" ]; then
	ok=0
fi

if [ $ok == 1 ]; then
	echo "# Area data already present ${FILELAST}"
else
	#call script to ensure base data is present
	$SCRIPTDIR/basedata_ensure.sh

	RES=$?
	if [ $RES -ne 0 ]; then
	    echo "Error: ($RES)!!! Exit..."
	    exit $RES
	fi

echo "#############################################################################
# $(date)
# Cutting base data on specified boundaries
# (this may take a few minutes)"

	BASEOSM_FILE="${DATADIR}/${BASEOSM_NAME}"

	if [ ${OSMCUT} == "PRESERVE" ]; then
echo "# cutting PRESERVE"	
		osmium extract --strategy smart -S complete-partial-relations=1 --bbox $AREA_BOUNDS $BASEOSM_FILE -o $FILELAST --overwrite
	else
		./osmconvert $BASEOSM_FILE -b=$AREA_BOUNDS --complete-ways -o=$FILELAST
	fi

	RES=$?
	if [ $RES -ne 0 ]; then
	    echo "Error ($RES)!!! Exit..."
	    exit $RES
	fi
fi

if [ ${OSMUPDATE_WHAT} != "BASE" ]; then
echo "#############################################################################
# $(date)
# Update area file
# (this may take a few minutes)"

	./osmupdate ${FILELAST} ${FILENOW} -b=$AREA_BOUNDS

	RES=$?
	if [ $RES -eq 21 ]; then				#in case no data changes present
		echo $RES
	else
		if [ $RES -ne 0 ]; then
			echo "Error ($RES)!!! Exit..."
			exit $RES
		fi
	fi

	mv ${FILENOW} ${FILELAST}
fi

echo "#############################################################################
# $(date)
# Done"
