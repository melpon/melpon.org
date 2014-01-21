#!/bin/bash

set -ex

su - melpon-org -c '
set -ex

cd melpon-org/
git checkout master
git pull

git submodule update -i

cd site
rm -r dist/
cabal-dev install
'
stop melpon-org || true
sleep 1
start melpon-org
