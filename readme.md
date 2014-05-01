
# Saucelabs Browsertime

Using Webdriver to collect Navigation Timing, on Saucelabs.

```
Usage: sauce-browsertime [options] [urls, ...]

    $ sauce-browsertime http://example.com -b firefox -n 3 --assert-pageload-max=5000 --assert-frontend-p90=2500

See https://saucelabs.com/platforms for the list of available OS / Browser / Version

Options:

  -b, --browser          - Saucelabs browser (default: chrome)
  -p, --platform         - Saucelabs platform (default: unspecified)
  -t, --type             - Saucelabs device type (default: unspecified)
  -o, --orientation      - Saucelabs device orientation (default: unspecified)
  -v, --version          - Saucelabs browser version (default: unspecified)
  -n, --runs             - Number of runs per URL (default: 1)
  -R, --reporter         - Mocha reporter (default: json)
  -H, --hostname         - Webdriver-grid hostname (default: ondemand.saucelabs.com)
  --port                 - Specify webdriver-grid port (default: 80)
  -h, --help

Asserts:

  --assert-name-stat=[value]   - Specify a test assertion on [name] metric
  --assert-name=value          - Specify a test assertion on [name] average value

Available stats: min, max, avg, media, mad, p60, p70, p80, p90
```

Every webdriver enabled browser on Saucelabs, implementing [Navigation Timing API](http://caniuse.com/#feat=nav-timing) should be supported.

## Install

    $ npm install saucelabs-browsertime -g

    # local
    $ npm install saucelabs-browsertime
    node_modules/.bin/sauce-browsertime -h

## Asserts

`--assert-*` params sets up test assertion on a specific interval and stat.

Stats are based on [https://github.com/tmcw/simple-statistics](https://github.com/tmcw/simple-statistics). Use the `-n, --runs` option to set the number of pageload per URL.

```
$ node bin/sauce-browsertime -h --assert-help

Asserts:

  --assert-name-stat=[value]   - Specify a test assertion on [name] metric
  --assert-name=value          - Specify a test assertion on [name] average valu
e


Metrics:

  --assert-domainLookup
  --assert-redirection
  --assert-serverConnection
  --assert-serverResponse
  --assert-pageDownload
  --assert-domInteractive
  --assert-domContentLoaded
  --assert-pageLoad
  --assert-frontEnd
  --assert-backEnd

Available stats: min, max, avg, media, mad, p60, p70, p80, p90
```

Example on [sauceio.com](http://sauceio.com), running 10 times, with
assertion on pageLoad, backandTime and frontendTime.

```
$ sauce-browsertime sauceio.com -n 10 \
  --assert-pageLoadTime-max=5000 \
  --assert-pageLoadTime-avg=2000 \
  --assert-backendTime-max=800 \
  --assert-backendTime-p90=700 \
  --assert-frontend=100 \
  --reporter spec

Collecting Navigation Timings with chrome
  sauceio.com
    √ sauceio.com #1
    √ sauceio.com #2
    √ sauceio.com #3
    √ sauceio.com #4
    √ sauceio.com #5
    √ sauceio.com #6
    √ sauceio.com #7
    √ sauceio.com #8
    √ sauceio.com #9
    √ sauceio.com #10

Asserts - sauceio.com
  √ Assert pageload max <= 5000 (Value: 285)
  √ Assert pageload avg <= 2000 (Value: 96.8)
  √ Assert backend max <= 800 (Value: 29)
  √ Assert backend p90 <= 700 (Value: 16.5)
  √ Assert frontend avg <= 100 (Value: 83.2)

  15 passing (23s)
```

## Reporters

Mocha reporters should be usable for the most part

    $ mocha --reporters

        dot - dot matrix
        doc - html documentation
        spec - hierarchical spec list
        json - single json object
        progress - progress bar
        list - spec-style listing
        tap - test-anything-protocol
        landing - unicode landing strip
        xunit - xunit reporter
        html-cov - HTML test coverage
        json-cov - JSON test coverage
        min - minimal reporter (great with --watch)
        json-stream - newline delimited json events
        markdown - markdown documentation (github flavour)
        nyan - nyan cat!


*few examples*

JSON (default)

    $ sauce-browsertime http://example.com -n 3 --reporter json
    {
      "stats": {
        "suites": 2,
        "tests": 3,
        "passes": 3,
        "pending": 0,
        "failures": 0,
        "start": "2014-04-30T21:28:43.124Z",
        "timings": {
          "http://example.com": {
            "domainLookupTime": {
              "min": 0,
              "max": 0,
              "avg": 0,
              "median": 0,
              "mad": 0,
              "p60": 0,
              "p70": 0,
              "p80": 0,
              "p90": 0
            },
            "redirectionTime": {
              "min": 0,
              "max": 0,
              "avg": 0,
              "median": 0,
              "mad": 0,
              "p60": 0,
              "p70": 0,
              "p80": 0,
              "p90": 0
            },
            "serverConnectionTime": {
              "min": 0,
              "max": 0,
              "avg": 0,
              "median": 0,
              "mad": 0,
              "p60": 0,
              "p70": 0,
              "p80": 0,
              "p90": 0
            },
            "serverResponseTime": {
              "min": 2,
              "max": 6,
              "avg": 4,
              "median": 4,
              "mad": 2,
              "p60": 4,
              "p70": 6,
              "p80": 6,
              "p90": 6
            },
            "pageDownloadTime": {
              "min": 0,
              "max": 1,
              "avg": 0.77777777777777777,
              "median": 1,
              "mad": 0,
              "p60": 1,
              "p70": 1,
              "p80": 1,
              "p90": 1
            },
            "domInteractiveTime": {
              "min": 17,
              "max": 46,
              "avg": 29.333333333333332,
              "median": 25,
              "mad": 8,
              "p60": 25,
              "p70": 46,
              "p80": 46,
              "p90": 46
            },
            "domContentLoadedTime": {
              "min": 17,
              "max": 46,
              "avg": 29.333333333333332,
              "median": 25,
              "mad": 8,
              "p60": 25,
              "p70": 46,
              "p80": 46,
              "p90": 46
            },
            "pageLoadTime": {
              "min": 19,
              "max": 46,
              "avg": 30,
              "median": 25,
              "mad": 6,
              "p60": 25,
              "p70": 46,
              "p80": 46,
              "p90": 46
            },
            "frontEndTime": {
              "min": 11,
              "max": 20,
              "avg": 14.333333333333334,
              "median": 12,
              "mad": 1,
              "p60": 12,
              "p70": 20,
              "p80": 20,
              "p90": 20
            },
            "backEndTime": {
              "min": 4,
              "max": 33,
              "avg": 15,
              "median": 8,
              "mad": 4,
              "p60": 8,
              "p70": 33,
              "p80": 33,
              "p90": 33
            }
          }
        },
        "caps": {
          "rotatable": false,
          "browserConnectionEnabled": false,
          "acceptSslCerts": false,
          "cssSelectorsEnabled": true,
          "javascriptEnabled": true,
          "databaseEnabled": false,
          "chrome.chromedriverVersion": "26.0.1383.0",
          "locationContextEnabled": false,
          "takesScreenshot": true,
          "platform": "linux",
          "browserName": "chrome",
          "version": "28.0.1500.95",
          "hasMetadata": true,
          "nativeEvents": true,
          "applicationCacheEnabled": false,
          "webStorageEnabled": true,
          "handlesAlerts": true
        },
        "end": "2014-04-30T21:28:52.644Z",
        "duration": 9520
      },
      "tests": [ ... includes raw timings here as duration props ... ],
      "passes": [ ... same as above ... ]

Spec

    $ sauce-browsertime http://example.com -n 3 --reporter spec

    Collecting Navigation Timings with chrome
      http://example.com
        √ http://example.com #1
        √ http://example.com #2
        √ http://example.com #3


      3 passing (11s)

Nyan!

    $ sauce-browsertime http://example.com http://example.com/page-one http://example.com/page-two -n 4 --reporter nyan

     12  -_-_-_-_-_-_-_,------,
     0   -_-_-_-_-_-_-_|   /\_/\
     0   -_-_-_-_-_-_-^|__( ^ .^)
         -_-_-_-_-_-_-  ""  ""

      12 passing (23s)

## HTML templates

Not a a mocha reporter per say. Transforms the raw JSON data of a
previous run into an HTML page, with visual representation of the Timing
objects thanks to http://kaaes.github.io/timing/

    Usage: sauce-browsertime-html [options] file.json

        $ sauce-browsertime results.json > index.html

    Graphs generated thanks to http://kaaes.github.io/timing/
    Browser logos thanks to https://github.com/alrra/browser-logos

    Options:

      -b, --browser          - Browser under test (used to match browser logo)

## Jenkins template

`config.xml` file is a Jenkins Job template that can be used to quickly
setup a Job to run the perf test, at a fixed interval or on SCM change:

- Includes Job parameters for:
  - `PERF_URLS`: List of URLs to test. Whitespace separated.
  - `SAUCE_USERNAME`: Saucelabs username
  - `SAUCE_ACCESS_KEY`: Saucelabs API key
  - `SAUCE_BROWSERS`: Comma separated list of browsers.

- Shell scripts
  - Install npm packages on first run (npm install saucelabs-browsertime)
  - A run for each browser, stats & raw metrics available at `./results/BUILD_NUMBER/BROWSER/metrics.json`, HTML report at `./results/BUILD_NUMBER/BROWSER/metrics.json`.

- Plugin configuration for htmlpublisher (optional to have it installed,
  jenkins will just ignore the conf)

See config.xml file for further detail.

    # Job creation
    $ curl -X POST -H 'Content-Type: application/xml' $JEKINS_URL/pluginManager/installNecessaryPlugins --data-binary @config.xml

    # Check plugins
    $ curl -X POST -H 'Content-Type: application/xml' $JEKINS_URL/pluginManager/prevalidateConfig --data-binary @config.xml

    # Install plugins
    $ curl -X POST -H 'Content-Type: application/xml' $JEKINS_URL/pluginManager/installNecessaryPlugins --data-binary @config.xml



### TODOs

- [] Statsd / Graphite reporter
- [x] Assert system (like phantomas)
- [x] HTML reporter with http://kaaes.github.io/timing/ widget
- [x] Option for the number of runs, and stats (avg, median, percentiles)
