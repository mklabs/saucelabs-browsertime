#!/bin/bash

BUILD_NUMBER=${BUILD_NUMBER:-last}
BUILD_NUMBER=${TRAVIS_BUILD_NUMBER:-last}
PERF_RUNS=1
CWD=$(pwd)

RESULT_DIR=results/$BUILD_NUMBER

BROWSERS=$(node -pe "b = require('./test/browsers.json').browsers.join(' ')")

echo "Output: $RESULT_DIR"

for browser in $BROWSERS; do
  echo "Creating dir $RESULT_DIR/$browser"
  mkdir -p $RESULT_DIR/$browser

  bro=$(node -pe "b = require('./test/browsers.json')['$browser']; b ? b.name : '$browser'")
  logo=$(node -pe "b = require('./test/browsers.json')['$browser']; b ? b.logo : '$browser'")
  echo "Testing $browser, resolved to $bro / $logo"

  node bin/sauce-browsertime test/urls.txt --browser "$bro" -n $PERF_RUNS \
    --output $RESULT_DIR/$browser/metrics.json \
    --reporter spec || exit 1

  echo "... Generate  $RESULT_DIR/$browser/index.html ..."
  node bin/sauce-browsertime-html $RESULT_DIR/$browser/metrics.json -b "$logo" > $RESULT_DIR/$browser/index.html

  echo "... Generate  $RESULT_DIR/$browser.html ..."
  node bin/sauce-browsertime-html $RESULT_DIR/$browser/metrics.json -b "$logo" >  $RESULT_DIR/$browser.html
done

echo "... Generate  $RESULT_DIR/index.html ..."
node test/build-index.js $RESULT_DIR > $RESULT_DIR/index.html

echo "... Generate  results/index.html ..."
node test/build-index.js $RESULT_DIR index > results/index.html

echo "... Generate results/last ..."
rm -rf result/last
cp -r $RESULT_DIR results/last

echo "... Generate index.html ..."
node test/build-index.js $RESULT_DIR index > index.html
