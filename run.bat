@echo off

docker run --network host --env-file %1 --rm -v amat-osmtools-data:/amat-osmtools-data amat-osmtools:2.2.0 %2 %3 %4 %5 %6 %7 %8 %9
