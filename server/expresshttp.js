var fs = require('fs');
var http = require('http');
var https = require('https');
//var privateKey  = fs.readFileSync('sslcert/server.key', 'utf8');
//var certificate = fs.readFileSync('sslcert/server.crt', 'utf8');

//var credentials = {key: privateKey, cert: certificate};
var express = require('express');
var app = express();
app.use(express.json())
app.use(express.urlencoded({extended: true}))
// your express configuration here

var httpServer = http.createServer(app);
//var httpsServer = https.createServer(credentials, app);

app.all('/*', function(req, res, next) {
  console.log('Intercepting requests ...',req.query);
  console.log('Intercepting body ...',req.body);
  console.log('Intercepting header ...',req.headers);
  next();  // call next() here to move on to next middleware/router
});

httpServer.listen(8082);
//httpsServer.listen(8443);
