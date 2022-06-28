#!/bin/bash

# Init osmosis (could be done una-tantum)
../../run.sh $1 osmosis_init.sh

# Copy osm2pgrouting configuration files into container (could be done una-tantum)
../../file_put.sh mapconfig_car.xml mapconfig_car.xml
../../file_put.sh mapconfig_foot.xml mapconfig_foot.xml
../../file_put.sh mapconfig_bike.xml mapconfig_bike.xml
