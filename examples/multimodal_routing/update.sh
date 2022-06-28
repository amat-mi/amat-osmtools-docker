#!/bin/bash

# Ensure OSM area data exists and is up to date
../../run.sh $1 areadata_ensure.sh

# Load OSM area data into PostGIS database (osmosis format)
../../run.sh $1 osmosis_load.sh

# Load OSM area data into PostGIS database (pgRouting format)
../../run.sh $1 pgrouting_load.sh car
../../run.sh $1 pgrouting_load.sh foot
../../run.sh $1 pgrouting_load.sh bike
