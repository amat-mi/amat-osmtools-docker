#!/bin/sh

DIR_OSMOSIS=$SCRIPTDIR/osmosis

# Install osmosis in "osmosis" directory
mkdir -p $DIR_OSMOSIS
mv $SCRIPTDIR/osmosis-latest.tgz $DIR_OSMOSIS
cd $DIR_OSMOSIS
tar xfz osmosis-latest.tgz
rm ./osmosis-latest.tgz
chmod a+x ./bin/osmosis
