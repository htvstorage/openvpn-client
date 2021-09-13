const http = require("http");
const console = require("console");
var util = require('util');
const fs = require('fs');
const host = 'localhost';
const port = 8000;
const path = require('path');
const url = require('url');

const requestListener = function (req, res) {
    // console.log(req);
    var urld = decodeURI(req.url);
    const parsedUrl = url.parse(req.url);
    // extract URL path
    let pathname = `.${parsedUrl.pathname}`;
    // based on the URL path, extract the file extention. e.g. .js, .doc, ...
    const ext = path.parse(pathname).ext;
    const map = {
        '.ico': 'image/x-icon',
        '.html': 'text/html',
        '.js': 'text/javascript',
        '.json': 'application/json',
        '.css': 'text/css',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.wav': 'audio/wav',
        '.mp3': 'audio/mpeg',
        '.svg': 'image/svg+xml',
        '.pdf': 'application/pdf',
        '.doc': 'application/msword'
      };
    switch (urld) {
        case "/player":
            break;
        case "":
            break;
        default:
            fs.exists(__dirname + urld, function (exists) {
                if (!exists) {
                    console.log("Not found!" + req.url);
                    res.setHeader("Content-Type", "text/html");
                    res.writeHead(500);
                    res.end("ERROR");
                    return;
                }
                fs.readFile(__dirname + urld,function(err, data){
                    if(err){
                      res.statusCode = 500;
                      res.end(`Error getting the file: ${err}.`);
                    } else {
                      // if the file is found, set Content-type and send data
                      res.setHeader('Content-type', map[ext] || 'text/plain' );
                      res.end(data);
                    }
                  });
            });

    }
};

const server = http.createServer(requestListener);
server.listen(port, host, () => {
    console.log(`Server is running on http://${host}:${port}`);
});
