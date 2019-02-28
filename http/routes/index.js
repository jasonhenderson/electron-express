/*
 * Copyright (C) 2017 Jason Henderson
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

// Another example of logging out within the child process
var log = require('electron-log');
log.transports.console.level = 'info';
log.transports.file.level = 'info';

var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    log.info('serving home page...');
    res.sendFile(path.join(__dirname + '../public/index.html'));
});
router.get('/open/:preq', function(req, res, next) {
    log.info('serving custom page...');
    var parameterRequest = new String(req.params.preq.trim()).valueOf();
    var parameterMatcher = new String("BCUI").valueOf();
    if(parameterRequest == parameterMatcher){
      log.info("Match ok, emitting...");
      res.status(200).end();
      process.send({value: "NEW-UI-WINDOW"});
    } else {
        log.info("Bad match on param...");
        res.status(201).end();
    }
});

module.exports = router;
