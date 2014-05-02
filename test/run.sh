#!/bin/bash

BUILD_NUMBER=${BUILD_NUMBER:-last}
BUILD_NUMBER=${TRAVIS_COMMIT:-last}
SAUCE_BROWSERS='chrome, firefox, ie'
PERF_URLS=${PERF_URLS:-"http://caniuse.com/nav-timing https://dvcs.w3.org/hg/webperf/raw-file/tip/specs/NavigationTiming/Overview.html"}
PERF_RUNS=3

RESULT_DIR=results/$BUILD_NUMBER

URLS="$PERF_URLS"
BROWSERS=$(node -pe "b = '$SAUCE_BROWSERS'; b.split(/,\s?/).join('\n')")
BROWSERS_HTML=$(node -pe "b = '$SAUCE_BROWSERS'; b.split(/,\s?/).join('.html ')")

# URL_KEY=$(node -pe 'process.argv.slice(1)[0].replace(/(^https?:\/\/)|(\/$)/g, "").replace(/(\/|\?|-|&amp;|=|\.)/g, "_")' "$url");

rm -rf results/last

for browser in $BROWSERS; do
  mkdir -p $RESULT_DIR/$browser
  bro=$browser

  if [[ "ie" == $browser ]]; then bro="internet explorer"; fi

  node bin/sauce-browsertime $PERF_URLS --browser "$bro" -n $PERF_RUNS \
    --output $RESULT_DIR/$browser/metrics.json \
    --reporter spec || exit 1

  [[ "android" == $browser ]] && bro="chrome-android"
  [[ "ie" == $browser ]] && bro="internet-explorer"

  if [[ "ie" == $browser ]]; then bro="internet explorer"; fi
  if [[ "android" == $browser ]]; then bro="chrome-android"; fi
  node bin/sauce-browsertime-html $RESULT_DIR/$browser/metrics.json -b "$bro" > $RESULT_DIR/$browser/index.html
  node bin/sauce-browsertime-html $RESULT_DIR/$browser/metrics.json -b "$bro" >  $RESULT_DIR/$browser.html
  head -n 75 $RESULT_DIR/$browser/metrics.json
done

cat > build-index.js << EOF
var fs = require('fs');
var path = require('path');

var dir = "$RESULT_DIR";

var files = fs.readdirSync(dir).filter(function(file) {
  return path.extname(file) === '.html' && file !== 'index.html';
});

var imgs = files.map(function(file) {
  var b = file.replace('.html', '');
  if (b === 'ie') b = 'internet-explorer';
  if (b === 'android') b = 'chrome-android';
  var img = '<img class="img-thumbnail" src="https://raw.githubusercontent.com/alrra/browser-logos/master/' + b + '/' + b + '_256x256.png" width="256" height="256" alt="' + b + '">';
  return '<a href="' + file + '">' + img + '</a>';
});

var body = [
'<!DOCTYPE html>',
'<html>',
'',
'<head>',
'',
'    <meta charset="utf-8">',
'    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
'',
'    <title>This page shows raw metrics generated by saucelabs-browsertime for the build $BUILD_NUMBER</title>',
'',
'    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">',
'    <link href="http://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">',
'    <style>',
'    .is-hidden { display: none; }',
'    body { padding: 80px; }',
'    </style>',
'</head>',
'<body>',
imgs.join('\n'),
'</body>',
'</html>'
];

console.log(body.join('\n'));

EOF

node build-index.js > $RESULT_DIR/index.html
rm build-index.js

