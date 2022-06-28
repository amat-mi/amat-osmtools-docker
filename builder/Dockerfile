FROM debian:bullseye

LABEL mantainer="AMAT-MI"

# Install useful tools
RUN apt-get update -y
RUN apt-get install wget -y
RUN apt-get install git -y

ENV SCRIPTDIR=/amat-osmtools/script

# Install compiling tools
RUN apt-get install gcc -y
RUN apt-get install make -y
RUN apt-get install build-essential -y

# Add latest version of cmake (see install.sh for installation)
# (check available versions here: https://cmake.org/download/)
RUN apt-get install expat -y

WORKDIR ${SCRIPTDIR}/cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3-linux-x86_64.sh -O cmake-latest.sh
RUN chmod ug+x,o= ./cmake-latest.sh && \
    ./cmake-latest.sh --prefix=/usr/local/ --exclude-subdir --skip-license && \
    rm ./cmake-latest.sh

# Clone osm2pgrouting repository and compile it
RUN apt-get install libexpat1-dev -y
RUN apt-get install libboost-dev -y
RUN apt-get install libboost-program-options-dev -y
RUN apt-get install libpqxx-dev -y

WORKDIR ${SCRIPTDIR}
RUN git clone https://github.com/pgRouting/osm2pgrouting.git
RUN cd osm2pgrouting && \
    cmake -H. -Bbuild && \
    cd build/ && \
    make && \
    make install

# Get osmconvert/osmupdate sources and compile them
RUN apt-get install zlib1g-dev -y

WORKDIR ${SCRIPTDIR}/osmupdate
RUN wget -O osmconvert.c http://m.m.i24.cc/osmconvert.c && \
    cc -x c osmconvert.c -lz -O3 -o osmconvert && \
    rm osmconvert.c
RUN wget -O osmupdate.c http://m.m.i24.cc/osmupdate.c && \
    cc -x c osmupdate.c -lz -O3 -o osmupdate && \
    rm osmupdate.c
