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
dartanalyzer lib/guinness2_html.dart

if [ $? -ne 0 ]; then
  echo Dart analyzer failed
  dartanalyzer lib/guinness2_html.dart
  exit 1
fi

sh -e /etc/init.d/xvfb start

function testAndVerifyOutput {
  echo ----------------
  echo "Executing command"
  echo $1
  echo ""
  res=$($1)
  echo "$res"
  echo ""
  results_line=`echo "$res" | tail -1`
  if [[ "$results_line" == *"$2"* ]]
  then
    echo "passed with correct expected output";
  else
    echo "ERROR: Expected [$results_line]"
    echo "to match [$2]"
    exit 1;
  fi
}

set +e

testAndVerifyOutput "pub run test test_e2e/common -r expanded --no-color" "+7 ~3: All tests passed"

testAndVerifyOutput "pub run test test_e2e/html -r expanded --no-color" "No tests ran"

testAndVerifyOutput "pub run test test_e2e/html -p dartium -r expanded --no-color" "+1: All tests passed"

# TODO - uncomment when focused tests are working.

testAndVerifyOutput "pub run test test_e2e/focused --tags solo -r expanded --no-color" "+1: All tests passed"

testAndVerifyOutput "pub run test test_e2e/focused_describe --tags solo -r expanded --no-color" "+2: All tests passed"

testAndVerifyOutput "pub run test -p dartium -r expanded --no-color" "+76: All tests passed"

testAndVerifyOutput "pub run test example/example.dart -p dartium -r expanded --no-color" "+5 ~4: All tests passed"
