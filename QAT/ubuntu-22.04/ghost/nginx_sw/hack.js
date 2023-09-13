/*
* Copyright (C) <2023-2023> Intel Corporation
* SPDX-License-Identifier: MIT
*/

// Hacks `fs.readFileSync()`. If the file requested is config.production.json
// and the environment variable NODE_REAL_ENV is set, then it replaces
// "production" in config.production.json with the value of the env var.

const fs = require('fs');
const path = require('path');
fs.readFileSync = (function(orig) {
  return function() {
    const dirname = path.dirname(arguments[0]);
    let filename = path.basename(arguments[0]);
    if (filename === 'config.production.json' && process.env.NODE_REAL_ENV) {
      console.log('Performed hack');
      filename = 'config.' + process.env.NODE_REAL_ENV + '.json';
    }
    arguments[0] = path.resolve(path.join(dirname, filename));
    return orig.apply(this, arguments);
  };
})(fs.readFileSync);
