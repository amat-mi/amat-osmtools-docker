#!/bin/bash

docker run --network host --env-file $1 --rm -v amat-osmtools-data:/amat-osmtools-data -v amat-osmtools-script:/amat-osmtools/script amat-osmtools:2.2.1 $2 $3 $4 $5 $6 $7 $8 $9
