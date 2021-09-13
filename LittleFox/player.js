const http = require("http");
const https = require('https');
var util = require('util');
const fs = require('fs');
const host = 'localhost';
const port = 8000;
const path = require('path');
const url = require('url');
const mapCache = {};
const jsdom = require("jsdom");

const getScript = (url) => {
    return new Promise((resolve, reject) => {
        let client = http;
        if (url.toString().indexOf("https") === 0) {
            client = https;
        }
        client.get(url, (resp) => {
            let data = '';
            // A chunk of data has been recieved.
            resp.on('data', (chunk) => {
                data += chunk;
            });
            // The whole response has been received. Print out the result.
            resp.on('end', () => {
                resolve(data);
            });
        }).on("error", (err) => {
            reject(err);
        });
    });
};


function parseCookies(request) {
    var list = {},
        rc = request.headers.cookie;

    rc && rc.split(';').forEach(function (cookie) {
        var parts = cookie.split('=');
        list[parts.shift().trim()] = decodeURI(parts.join('='));
    });

    return list;
}

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
var stringToHTML = function (str) {
	var parser = new DOMParser();
	var doc = parser.parseFromString(str, 'text/html');
	return doc;
};

const requestListener = function (req, res) {
    // console.log(req);
    var urld = decodeURI(req.url);
    const parsedUrl = url.parse(req.url);
    // extract URL path
    let pathname = `.${parsedUrl.pathname}`;
    // based on the URL path, extract the file extention. e.g. .js, .doc, ...
    const ext = path.parse(pathname).ext;
    // console.log(parsedUrl);
    if (urld.indexOf('/littlefox/player/') >= 0) {
        var storyId = "";
        var videoId = "";
        var idx = "";
        var tmp = urld.substr(urld.indexOf("player/") + "player/".length);
        storyId = tmp.substr(0, tmp.indexOf('?'));
        if (tmp.indexOf('idx=') >= 0) {
            var length = (tmp.indexOf('&', tmp.indexOf('idx=')) == -1 ?
                tmp.length : tmp.indexOf('&', tmp.indexOf('idx='))) - tmp.indexOf('idx=') - 'idx='.length;
            idx = tmp.substr(tmp.indexOf('idx=') + 'idx='.length, length);
        }
        if (tmp.indexOf('id=') >= 0) {
            length = (tmp.indexOf('&', tmp.indexOf('id=')) == -1 ? tmp.length : tmp.indexOf('&', tmp.indexOf('id='))) - tmp.indexOf('id=') - 'id='.length;
            videoId = tmp.substr(tmp.indexOf('id=') + 'id='.length, length);
        }
        console.log(tmp);
        console.log('storyId:' + storyId);
        console.log('idx:' + idx);
        console.log('videoId:' + videoId);
        var turl = "https://www.littlefox.com/en/readers/contents_list/" + storyId;
        var xc= getScript(turl);
        xc.then(data => {
            console.log(data)
            res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
            res.end(data);

           const dom = new jsdom.JSDOM(data.toString());
           var a= dom.window.document.querySelectorAll('tr[data-fcid]');
           for (let i of a) {
            console.log("============" +i.getAttribute("data-fcid"));
            x=i.getAttribute("data-fcid");
            // x1=x.substr("javascript:Player.view(".length,x.length);
            // //console.log(x1);
            // x1=x1.substr(0,x1.indexOf(","));
            x1=x;
            x1=x1.replace(/\"/g,"");
            console.log(x1);
            //base64_encode("{\"fc_ids\":\"C0007022\",\"w\":1288,\"h\":810}")
            v="{\"fc_ids\":\""+x1+"\",\"w\":1288,\"h\":810}";
            console.log(v);
            var buff = new Buffer(v);
            var base64data = buff.toString('base64');

            console.log(base64data);

            
            buff = new Buffer(base64data, 'base64');
            let text = buff.toString('ascii');
            console.log(text);
            // ax[ii] = base64_encode(v);
            // ii++;
           }
        });
        return;
    }


    var cookies = parseCookies(req);
    switch (cookies['root']) {
        case '/littlefox', "littlefox":
            var turl = "";
            if (urld != "/littlefox") {
                turl = "https://www.littlefox.com/" + urld;
            } else {
                turl = "https://www.littlefox.com/en";
            }
            var x = getScript(turl);
            x.then(data => {
                // console.log(data)
                res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
                res.end(data);
            });
            return;
    }

    switch (urld) {
        case "/littlefox", "/littlefox/", '/littlefox', '/littlefox/':
            var x = getScript("https://www.littlefox.com/en");
            x.then(data => {
                // console.log(data)
                res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
                res.end(data);
            });
            // console.log(x.);
            break;
        case "/littlefox/player":
            break;
        case "":
            break;
        default:
            // console.log(mapCache[urld])
            if (mapCache[urld] != null) {
                res.setHeader('Content-type', map[ext] || 'text/plain');
                res.end(mapCache[urld]);
                // console.log("Return");                  
                return;
            }
            fs.exists(__dirname + urld, function (exists) {
                if (!exists) {
                    console.log("Not found!" + req.url);
                    res.setHeader("Content-Type", "text/plain");
                    res.writeHead(500);
                    res.end("ERROR");
                    return;
                }
                fs.readFile(__dirname + urld, function (err, data) {
                    if (err) {
                        res.statusCode = 500;
                        res.end(`Error getting the file: ${err}.`);
                    } else {
                        // if the file is found, set Content-type and send data
                        res.setHeader('Content-type', map[ext] || 'text/plain');
                        res.end(data);
                        mapCache[urld] = data;
                    }
                });
            });

    }
};

const server = http.createServer(requestListener);
server.listen(port, host, () => {
    console.log(`Server is running on http://${host}:${port}`);
});
