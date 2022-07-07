@echo off

set FILE_PUT_SRC=%1
set FILE_PUT_DST=%2

docker container create -t --name amat-osmtools-dummy -v amat-osmtools-script:/amat-osmtools/script amat-osmtools:2.2.1 /bin/bash
docker cp %FILE_PUT_SRC% amat-osmtools-dummy:/amat-osmtools/script/%FILE_PUT_DST%
docker start amat-osmtools-dummy
docker exec amat-osmtools-dummy chmod ug+x,o= /amat-osmtools/script/%FILE_PUT_DST%
docker exec amat-osmtools-dummy dos2unix /amat-osmtools/script/%FILE_PUT_DST%
docker stop amat-osmtools-dummy
docker rm amat-osmtools-dummy
