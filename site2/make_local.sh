#!/bin/sh

set -ex
echo $1

if [ "$1" = "all" ]; then
  ./autogen.sh
  ./configure CXXFLAGS="-g3 -O0 -rdynamic" --prefix=/home/melpon/melpon.org/site2/install --with-cppcms=/usr/local/cppcms --with-cppdb=/usr/local/cppdb
fi

make
echo 'starting server'
src/melpon.org -c config_local.json
