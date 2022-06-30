# Get OSM data into PostGIS in Osmosis format

This environment is for keeping a local copy of OSM data up to date inside a PostGIS database in the "raw" osmosis "0.6" format.

## Configure

### Parameters

A copy of the provided __env.txt.sample__ sample file must be created with a different name (without the ".sample" extension).
Inside each env file required parameters must be set (see comments inside sample file).

Be careful NOT to modifify parameters:

    OSMUPDATE_WHAT=AREA
    OSMCUT=CUT

that MUST be set exactly like that.

## Initialize database

Open up a terminal window and execute the following command:

* Linux => ../../run.sh ENV-FILE-NAME osmosis_init.sh
* Windows => ..\..\run.bat ENV-FILE-NAME osmosis_init.sh

If database is already initialized it will not be initialized again.

## Update database

Open up a terminal window and execute the following command:

* Linux => ../../run.sh ENV-FILE-NAME osmosis_ensure.sh
* Windows => ..\..\run.bat ENV-FILE-NAME osmosis_ensure.sh

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
