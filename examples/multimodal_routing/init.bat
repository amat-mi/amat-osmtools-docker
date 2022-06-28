@echo off

REM Init osmosis (could be done una-tantum)
CALL ..\..\run.bat %1 osmosis_init.sh

REM Copy osm2pgrouting configuration files into container (could be done una-tantum)
CALL ..\..\file_put.bat mapconfig_car.xml mapconfig_car.xml
CALL ..\..\file_put.bat mapconfig_foot.xml mapconfig_foot.xml
CALL ..\..\file_put.bat mapconfig_bike.xml mapconfig_bike.xml
