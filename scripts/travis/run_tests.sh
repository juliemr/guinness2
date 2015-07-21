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

echo -------------------
echo Dart analyzer
echo -------------------
which dart
which dartanalyzer
which dartium
dartanalyzer lib/guinnessb_html.dart

if [ $? -ne 0 ]; then
  echo Dart analyzer failed
  dartanalyzer lib/guinnessb_html.dart
  exit 1
fi


echo -------------------
echo "Pub run test"
echo -------------------
sh -e /etc/init.d/xvfb start
pub run test -p dartium

echo -------------------
echo "Pub run test examples"
echo -------------------
pub run test example/example.dart -p dartium
