#!/bin/bash

echo "#############################################################################
# $(date)
# Starting: $(basename $0)"
echo "#############################################################################"

./areadata_ensure.sh
if [ $? -ne 0 ]; then
    exit
fi

./osmosis_load.sh