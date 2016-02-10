#!/bin/bash

set -e

DARTIUM_DIST=dartium-linux-x64-release.zip

echo -------------------
echo Fetching dartium
echo -------------------

curl http://storage.googleapis.com/dart-archive/channels/stable/raw/latest/dartium/$DARTIUM_DIST > $DARTIUM_DIST


unzip $DARTIUM_DIST > /dev/null
rm $DARTIUM_DIST
mv dartium-* dartium;
ln dartium/chrome dartium/dartium

export DARTIUM_BIN="$PWD/dartium"
export PATH="$DARTIUM_BIN:$PATH"

sh -e /etc/init.d/xvfb start