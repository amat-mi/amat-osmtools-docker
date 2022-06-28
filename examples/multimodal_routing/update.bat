@echo off

REM Ensure OSM area data exists and is up to date
CALL ..\..\run.bat %1 areadata_ensure.sh

REM Load OSM area data into PostGIS database (osmosis format)
CALL ..\..\run.bat %1 osmosis_load.sh

REM Load OSM area data into PostGIS database (pgRouting format)
CALL ..\..\run.bat %1 pgrouting_load.sh car
CALL ..\..\run.bat %1 pgrouting_load.sh foot
CALL ..\..\run.bat %1 pgrouting_load.sh bike
