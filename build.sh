#!/bin/sh

HERE=$(pwd)

# Start by making a release
mix release.clean
mix release

# compile elm
cd elm

elm make src/Main.elm --output elm.js

cd $HERE

# build the docker image
docker build . -t elm:elm

