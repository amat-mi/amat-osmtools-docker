@echo off

docker run --network host --env-file %1 -it --rm -v amat-osmtools-data:/amat-osmtools-data -v amat-osmtools-script:/amat-osmtools/script amat-osmtools:2.2.1
