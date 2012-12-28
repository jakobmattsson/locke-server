#!/usr/bin/env node

var nconf = require('nconf');
var fs = require('fs');
var path = require('path');
var optimist = require('optimist');
var server = require('../lib/server');
var emailFactory = require('../lib/email');

var argv = optimist
  .usage('Runs a locke server')
  .describe('app', 'Creates an app with the given name with an internal owner')
  .describe('mongo', 'The mongo db connection string (only used in production mode)')
  .describe('emailHost', 'SMTP host (only used in production mode)')
  .describe('emailUser', 'SMTP user (only used in production mode)')
  .describe('emailPassword', 'SMTP password (only used in production mode)')
  .describe('port', 'Port to run the server on')
  .describe('version', 'Print the current version number')
  .describe('help', 'Show this help message')
  .default('port', 6002)
  .default('mongo', 'mongodb://localhost/locke')
  .alias('port', 'p')
  .alias('version', 'v')
  .alias('help', 'h')
  .argv;

process.on('uncaughtException', function(err) {
  console.log(err);
});

if (argv.help) {
  console.log(optimist.help());
  return;
}
if (argv.version) {
  console.log(require('../package.json').version);
  return;
}

nconf.env().defaults(argv);

var port = nconf.get('port');

if (process.env.NODE_ENV === 'production') {
  server.construct({
    hashRounds: 10,
    port: port,
    emailClient: emailFactory.setup({
      user: nconf.get('emailUser'),
      password: nconf.get('emailPassword'),
      host: nconf.get('emailHost')
    })
  })
} else {
  server.construct({
    hashRounds: 1,
    port: port,
    emailClient: {
      send: function(to, content, callback) {
        callback();
      }
    }
  })
}
console.log("Running locke server on port " + port);
