var express = require('express');
var vitals = require('./vitals');
var app = express();

app.post('/flatten', require('./flatten'));
app.post('/find', express.json(), require('./find'));
app.get('/health', vitals.express);

module.exports = app;