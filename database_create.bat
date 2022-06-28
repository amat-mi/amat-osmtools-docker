@echo off

docker run --network host --env-file %1 -it --rm -v amat-osmtools-data:/amat-osmtools-data amat-osmtools:2.2.0 database_create.sh
