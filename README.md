# Introduction

This repository is about retrieving data from OSM and storing it inside a local PostGIS database for purposes such as to keap a local copy of OSM data up to date, or deriving a routable road network.

It uses two Docker containers, one for building binaries of needed tools out of their source code ("builder/Dockerfile"), and the other one for running all relevant scripts and tools ("container/Dockerfile").
Using Docker containers abstracts local machines differences and let the scripts and tools run inside a known Linux environment, even on Windows machines.

Inside the run time container a non volatile data volume is created (mounted on "/amat-osmtools-data") to store OSM data between one invocation of a run time script and the following one, so that base OSM data has not to be dowloaded each time.

A few scripts, for Windows and Linux, are provided to be run inside the local machine and a few more, Linux only, to be run inside the run time container.

For each area of interest an env file must be created with all relevant parameters (see the provided __env.txt.sample__ file).

OSM base data is downloaded from a remote source and it is __highly__ recommended to choose a source where portions of the world are already cut out, by specifying its URL inside the env file by means of the __BASEOSM_URL__ parameter.

From this base data, multiple area data can be cut out, by means of the __AREA_BOUNDS__ parameter.

Each env file has to be relative to a single area of interest, and a different __DB_NAME__ must be specified for each of them, because the data of each area is stored inside a specific PostGIS database, always in "public" schema.

At the same manner, a different __AREA_NAME__ parameter must be specified inside each env file, because area data is stored inside the container with a file name constructed out of that parameter value.

# Installation

Install Docker:

    https://docs.docker.com/get-docker/

Clone this repository into any directory on the machine where Docker is installed.

## Linux

Open up a terminal window and execute the following script:

    setup.sh

Should errors arise of not having permissions to run docker, try the following commands:

    sudo groupadd docker
    sudo usermod -aG docker $USER

## Windows

Open up a terminal window and execute the following script:

    setup.bat

# Configuration

Copy provided sample file:

    env.txt.sample

to a new file with a meaningful name, for example:

    env-milano.txt

and edit this new file, setting all needed parameters (see comments inside sample file).

# Create database

Open up a terminal window and execute the following command:

* Linux => ./database_create.sh ENV-FILE-NAME
* Windows => database_create.bat ENV-FILE-NAME

If database already exists it will not be created.

If manually creating the database, the following extensions must also be created:

``` sql
CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
```

# File copying

## To the container

Open up a terminal window and execute the following script:

* Linux => ./file_put.sh SRC-FILE-NAME DST-FILE-NAME
* Windows => file_put.bat SRC-FILE-NAME DST-FILE-NAME

The SRC-FILE-NAME must specify the path to a file accessible from the local machine,
that will be copied to the container into the "/amat-tools-data" directory
with the specified DST-FILE-NAME name.

WARNING! The destionation file will be overwritten if already present!

## From the container

Open up a terminal window and execute the following script:

* Linux => ./file_get.sh SRC-FILE-NAME DST-FILE-NAME
* Windows => file_get.bat SRC-FILE-NAME DST-FILE-NAME

The SRC-FILE-NAME is the name of a file inside the "/amat-tools-data" directory
that will be copied to the local machine in the position specified
by the DST-FILE-NAME path.

WARNING! The destionation file will be overwritten if already present!

# Script copying

## To the container

Open up a terminal window and execute the following script:

* Linux => ./script_put.sh SRC-FILE-NAME DST-FILE-NAME
* Windows => script_put.bat SRC-FILE-NAME DST-FILE-NAME

The SRC-FILE-NAME must specify the path to a file accessible from the local machine,
that will be copied to the container into the "/amat-tools/script" directory
with the specified DST-FILE-NAME name.

WARNING! The destionation file will be overwritten if already present!

Once copied into the container, a script can be executed like any of the script herein provided.

# Running commands

The run time container commands can be executed by opening a shell.

Open up a terminal window and execute the following script:

* Linux => ./shell.sh ENV-FILE-NAME
* Windows => shell.bat ENV-FILE-NAME

This script opens up a shell into the container where run time commands may be executed.

Or they can be executed directly using the __run__ script.

Open up a terminal window and execute the following script:

* Linux => ./run.sh ENV-FILE-NAME COMMAND-NAME ARGS
* Windows => run.bat ENV-FILE-NAME COMMAND-NAME ARGS

This script runs the specified run time command "COMMAND-NAME" __inside__ the container.

# Run time commands

These commands are run __inside__ the container, either by opening a shell into it and then running them, or by using the __run__ script, as already described.

Note that run time commands, unless specified, does NOT take any command line arguments, because all relevant parameters are already set by means of the env file specified while opening the container shell (__shell__ script), or running them (__run__ script).

## database_create.sh

Create an empty PostGIS database.

Does nothing if the database already exists.

## basedata_ensure.sh

Retrieve base data from OSM or third party server.

Does nothing if base data already retrieved and not too old.

## basedata_clear.sh

Delete base data previously retrieved.

Does nothing if base data is not present.

## areadata_ensure.sh

Update area data to current time.

If area data not present or too old, cut it out from base data, before updating.

If base data non present or too old, it is retrieved first.

## areadata_clear.sh

Delete area data previously retrieved.

Does nothing if area data is not present.

## osmosis_init.sh

Initialize an empty PostGIS database for storing data in osmosis format.

Does nothing if the database already exists or it is already initialized.

## osmosis_ensure.sh

Update area data to current time and then load it into the PostGIS database, replacing previous content.

For an area as large as a big city (i.e. Milano), it will need roughly half an hour each time,
because the loading of area data into PostGIS database will always take the same amount of time,
even if there are small changes, because each time the entire data is loaded,
not just the differences.

## osmosis_load.sh

Load area data into the PostGIS database in osmosis format, replacing previous content.

For an area as large as a big city (i.e. Milano), it will need roughly half an hour each time,
because the loading of area data into PostGIS database will always take the same amount of time,
even if there are small changes, because each time the entire data is loaded,
not just the differences.

## osmosis_clear.sh

Delete area data previously loaded into the PostGIS database.

## postgis_customsql.sh

Execute a custom .SQL file into the PostGIS database.

The file must have been previously copied to the container using the __file_put__ script.

First command line argument of this command must the be the file name.

Second command line argument can be "1" if PostGIS super user credentials are needed to run the .SQL inside the file (i.e. if any "privileged" SQL is issued, the "1" command line argument MUST be specified, and the __SUPER_USER__ and __SUPER_PASSWORD__ parameters MUST be set inside the env file).

For example:

    Windows
    file_put.bat my_custom.sql my_custom.sql
    run.bat ENV-FILE-NAME postgis_customsql.sh my_custom.sql
    OR
    run.bat ENV-FILE-NAME postgis_customsql.sh my_custom.sql 1

    Linux
    ./file_put.sh my_custom.sql my_custom.sql
    ./run.sh ENV-FILE-NAME postgis_customsql.sh my_custom.sql
    OR
    ./run.sh ENV-FILE-NAME postgis_customsql.sh my_custom.sql 1

## pgrouting_load.sh

Load area data into the PostGIS database in pgRouting format, replacing previous content.

A transport "mode" must be specified as the first parameter, that correspond with the suffix of one __mapconfig__ file, previously copied into the run time container with the __file_put__ script.

For example:

    Windows
    file_put.bat mapconfig_car.xml mapconfig_car.xml
    run.bat ENV-FILE-NAME pgrouting_load.sh car

    Linux
    ./file_put.sh mapconfig_car.xml mapconfig_car.xml
    ./run.sh ENV-FILE-NAME pgrouting_load.sh car

Note that for pgRouting to work, following values MUST be specified inside the env file:

    OSMUPDATE_WHAT=BASE
    OSMCUT=PRESERVE

# Examples

The __examples__ directory contains a few example environments, suitable for common situations.
See their respective __README__ for details.

# License considerations

The license of this repository only covers the content of the repository itself.

This repository does not distribute any software.

Upon creation of container images, several software packages are retrieved and used, and each one of them may have a different license that you (the user of this repository) must obey to.
