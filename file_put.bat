@echo off

set FILE_PUT_SRC=%1
set FILE_PUT_DST=%2

docker container create --name amat-osmtools-dummy -v amat-osmtools-data:/amat-osmtools-data amat-osmtools:2.2.0
docker cp %FILE_PUT_SRC% amat-osmtools-dummy:/amat-osmtools-data/%FILE_PUT_DST%
docker rm amat-osmtools-dummy
