FROM openjdk:8 as java

LABEL mantainer="AMAT-MI"

# Install useful tools
RUN apt-get update -y
RUN apt-get install wget -y
RUN apt-get install nano -y
RUN apt-get install iputils-ping -y
RUN apt-get install net-tools -y
RUN apt-get install dos2unix -y

# This MUST be equal to the mounting points of "amat-osmtools-data" volume 
# that is specified on the command line when running containers
ENV DATADIR=/amat-osmtools-data

ENV SCRIPTDIR=/amat-osmtools/script

# Add latest version of osmosis (see install.sh for installation)
# (check available versions here: https://github.com/openstreetmap/osmosis/releases)
WORKDIR ${SCRIPTDIR}
ADD https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz osmosis-latest.tgz

# Create "osmupdate" directory and install relevant tools into it
WORKDIR ${SCRIPTDIR}/osmupdate
COPY ./osmupdate .
COPY ./osmconvert .
RUN chmod ug+x,o= *

# Install osmium-tool
RUN apt-get install osmium-tool -y

# Install osm2pgrouting
RUN apt-get install libexpat1-dev -y
RUN apt-get install libboost-dev -y
RUN apt-get install libboost-program-options-dev -y
RUN apt-get install libpqxx-dev -y

COPY ./osm2pgrouting /usr/local/bin/osm2pgrouting
RUN chmod ugo+x,o= /usr/local/bin/osm2pgrouting

# Install PostgreSQL client tools
RUN apt-get install postgresql-client -y

# Execute installation steps inside container and then remove installation script
WORKDIR /
COPY install.sh .
RUN dos2unix ./install.sh
RUN chmod ug+x ./install.sh
RUN ./install.sh
RUN rm ./install.sh

# Add base script directory to system PATH,
# so that scripts can be run without prepending "./" each time
ENV PATH=${PATH}:${SCRIPTDIR}
RUN echo "PATH=${PATH}" >> /etc/bash.bashrc
RUN echo "export PATH" >> /etc/bash.bashrc

# Copy all scripts inside the container and make them executable
WORKDIR ${SCRIPTDIR}
COPY ./*.sh ./
RUN dos2unix ./*.sh
RUN chmod ug+x,o= ./*.sh
