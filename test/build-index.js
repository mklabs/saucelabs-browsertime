var fs = require('fs');
var path = require('path');
var browsers = require('./browsers.json');

var args = process.argv.slice(2);
var dir = args[0];
var index = args[1] === 'index';

// link helper
var prefix = process.env.HTML_PREFIX || '/';
function a(href, txt, title) {
  title = title || href;
  return '<a href="$href" title="$title">$txt</a>'
    .replace(/\$href/, prefix + href)
    .replace(/\$txt/, txt)
    .replace(/\$title/, title);
}

// Env
var env = process.env;
env.BUILD_NUMBER = env.BUILD_NUMBER || env.TRAVIS_BUILD_NUMBER || 'last';
env =
  ['BUILD_NUMBER', 'TRAVIS_BUILD_ID', 'TRAVIS_BUILD_NUMBER', 'TRAVIS_REPO_SLUG']
  .map(function(key) { return { name: key, value: process.env[key] || key };  })
  .reduce(function(env, prop) { env[prop.name] = prop.value; return env; }, {});

env.RESULT_DIR = dir;

if (index) dir = path.join(dir, '..');

var files = fs.readdirSync(dir).filter(function(file) {
  return index ? fs.statSync(path.join(dir, file)).isDirectory() : path.extname(file) === '.html' && file !== 'index.html';
});

var links = index ? files.map(function(file) {
  var txt = file === 'last' ? 'Last build' : 'Build #' + file;
  var link = a(dir + '/' + file + '/', txt);
  return '<p>' + link + '</p>';
}) : files.map(function(file) {
  var b = file.replace('.html', '');
  var browserDir = dir + '/' + b + '/';

  if (browsers[b]) b = browsers[b];
  else b = { name: b, logo: b };

  var img = '<img class="img-thumbnail" src="https://raw.githubusercontent.com/alrra/browser-logos/master/' + b.logo + '/' + b.logo + '_256x256.png" width="256" height="256">';
  return a(browserDir, img, b.name);
});


var s3 = 'https://s3.amazonaws.com/archive.travis-ci.org/jobs';

var body = [
'<!DOCTYPE html>',
'<html>',
'',
'<head>',
'',
'    <meta charset="utf-8">',
'    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
'',
'    <title>' + (index ? 'Build list - ' : '') + 'This page shows raw metrics generated by saucelabs-browsertime for the build ' + env.BUILD_NUMBER + '</title>',
'    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">',
'',
'    <style>',
'    .is-hidden { display: none; }',
'    body { padding: 80px; }',
'    </style>',
'</head>',
'<body>',
'',
'',
links.join('\n'),
'',
'<hr />',
'',
'<p>Last build: ' + a( env.RESULT_DIR + '/', 'Build #' + env.BUILD_NUMBER) + ' / ',
'',
'<a href="https://travis-ci.org/' + env.TRAVIS_REPO_SLUG + '/builds/' + env.TRAVIS_BUILD_ID + '">Travis Job</a> / ',
'<a href="' + s3 + '/' + env.TRAVIS_BUILD_ID + '/log.txt">Logs</a>',
'</p>',
'',
'</body>',
'</html>'
];

console.log(body.join('\n'));
