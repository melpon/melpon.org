#!/bin/bash

set -ex

su - melpon-org -c '
set -ex

cd melpon-org/
git clean -xdqf
git checkout master
git clean -xdqf
git pull

cd site2
./autogen.sh
./configure --prefix=/usr/local/melpon-org --with-cppcms=/usr/local/cppcms --with-cppdb=/usr/local/cppdb
make
'
cd /home/melpon-org/melpon-org/site2
make install
systemctl stop kennel
sleep 1
systemctl start kennel
