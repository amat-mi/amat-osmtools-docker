# Multimodal routing

This environment is for multimodal routing upn OSM data inside specific areas.

Data is loaded into a PostGIS database both in the "raw" osmosis "0.6" format and in the format suited for pgrouting (using osm2pgrouting).

## Configure

### Parameters

A copy of the provided __env.txt.sample__ sample file must be created with a different name (without the ".sample" extension).
Inside each env file required parameters must be set.

Be careful NOT to modifify parameters:

    OSMUPDATE_WHAT=BASE
    OSMCUT=PRESERVE

that MUST be set exactly like that.

### osm2pgrouting

Three "standard" __mapconfig__ files are provided for __bike__, __car__ and __foot__ modes.
These files can be modified as needed (see osm2pgrouting documentation).

## Initialize

Init command must be executed at least once and each time a __mapconfig__ file is modified:

* Linux => ./init.sh ENV-FILE-NAME
* Windows => init.bat ENV-FILE-NAME

## Update

Update command must be executed every time fresh data must be obtained from OSM and loaded into PostGIS:

* Linux => ./update.sh ENV-FILE-NAME
* Windows => update.bat ENV-FILE-NAME
