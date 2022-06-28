# Introduction

OSM "base" data is downloaded from a remote source.
It is __highly__ recommended to use a source where portions of the world are already cut out.

From this "base", data for a single "area", delimited by a boundaries rectangle, is cut out.

Data of each "area" is stored inside a specific PostGIS database, in "public" schema.

Copy provided sample file:

    env.txt.sample

to a new file with a meaningful name, for example:

    env-milano.txt

and edit this new file, setting all needed values.

# Installation

Install Docker:

    https://docs.docker.com/get-docker/

Clone this repository into any directory on the machine where Docker is installed.

## Linux

Open up a terminal window and execute the following command:

    setup.sh

Should errors arise of not having permissions to run docker, try the following commands:

    sudo groupadd docker
    sudo usermod -aG docker $USER

## Windows

Open up a terminal window and execute the following command:

    setup.bat
    
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

Open up a terminal window and execute the following command:

* Linux => ./file_put.sh SRC-FILE-NAME DST-FILE-NAME
* Windows => file_put.bat SRC-FILE-NAME DST-FILE-NAME

The SRC-FILE-NAME must specify the path to a file accessible from the local machine,
that will be copied to the container into the "/amat-tools-data" directory
with the specified DST-FILE-NAME name.

WARNING! The destionation file will be overwritten if already present!

## From the container

Open up a terminal window and execute the following command:

* Linux => ./file_get.sh SRC-FILE-NAME DST-FILE-NAME
* Windows => file_get.bat SRC-FILE-NAME DST-FILE-NAME

The SRC-FILE-NAME is the name of a file inside the "/amat-tools-data" directory
that will be copied to the local machine in the position specified
by the DST-FILE-NAME path.

WARNING! The destionation file will be overwritten if already present!

# Advanced commands

The following commands can be executed by opening a shell.

Open up a terminal window and execute the following command:

* Linux => ./shell.sh ENV-FILE-NAME
* Windows => shell.bat ENV-FILE-NAME

This command opens up a shell into the container where advanced commands may be executed.

Or they can be executed directly through the "run" command.

Open up a terminal window and execute the following command:

* Linux => ./run.sh ENV-FILE-NAME COMMAND-NAME ARGS
* Windows => run.bat ENV-FILE-NAME COMMAND-NAME ARGS

This command runs the specified command __inside__ the container.

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

Load area data it into the PostGIS database, replacing previous content.

For an area as large as a big city (i.e. Milano), it will need roughly half an hour each time,
because the loading of area data into PostGIS database will always take the same amount of time,
even if there are small changes, because each time the entire data is loaded,
not just the differences.

## osmosis_clear.sh

Delete area data previously loaded into the PostGIS database.

## postgis_customsql.sh

Execute a custom .SQL file into the PostGIS database.

The file must have been previously copied to the container using the __file_put__ command.

First parameter of this command must the be the file name.

Second parameter can be "1" if PostGIS super user credentials are needed to run the .SQL inside the file.

# Osmosis

## Initialize database

Open up a terminal window and execute the following command:

* Linux => ./run.sh ENV-FILE-NAME osmosis_init.sh
* Windows => run.bat ENV-FILE-NAME osmosis_init.sh

If database is already initialized it will not be initialized again.

## Update database

Open up a terminal window and execute the following command:

* Linux => ./run.sh ENV-FILE-NAME osmosis_ensure.sh
* Windows => run.bat ENV-FILE-NAME osmosis_ensure.sh

Every time this command is executed, it will carry on every action that is needed
to update an area date inside the PostGIS database.

This means dowloading base data from OSM, cutting out area boundaries, updating area data to current timestamp and replacing database content with updated area data.

All actions are executed only if and when needed.

This command can be added as a crontab on Linux or as a Planned operation on Windows,
but it's running frequency must be adjusted so that each invocation has sufficient time to complete
before the next one starts.

For an area as large as a big city (i.e. Milano), it will need roughly half an hour each time,
because the loading of area data into PostGIS database will always take the same amount of time,
even if there are small changes, because each time the entire data is loaded,
not just the differences.

# pgRouting

## Configuration files

Open up a terminal window and execute the following command:

* Linux => ./file_put.sh SRC-CONF-FILE-NAME DST-CONF-FILE-NAME
* Windows => file_put.bat SRC-CONF-FILE-NAME DST-CONF-FILE-NAME

for each osm2pgrouting configuration file that is needed.

The convention is to name configuration files after the transportation mode they are tailored to,
for example:

* Linux => ./file_put.sh mapconfig_car.xml mapconfig_car.xml
* Windows => file_put.bat mapconfig_car.xml mapconfig_car.xml

# Examples

The __examples__ directory contains a few example environments, suitable for common situations.
See their respective __README__ for details.
