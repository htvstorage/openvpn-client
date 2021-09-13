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
        var xc = getScript(turl);
        var resData = [];
        var ops = [];
        var mapId = {};
        var mapContentId = {};
        xc.then(data => {
            // console.log(data)
            // res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
            // res.end(data);

            const dom = new jsdom.JSDOM(data.toString());
            var a = dom.window.document.querySelectorAll('tr[data-fcid]');
            for (let i of a) {
                console.log("============" + i.getAttribute("data-fcid"));
                x = i.getAttribute("data-fcid");
                // x1=x.substr("javascript:Player.view(".length,x.length);
                // //console.log(x1);
                // x1=x1.substr(0,x1.indexOf(","));
                x1 = x;
                x1 = x1.replace(/\"/g, "");
                console.log(x1);
                //base64_encode("{\"fc_ids\":\"C0007022\",\"w\":1288,\"h\":810}")
                v = "{\"fc_ids\":\"" + x1 + "\",\"w\":1288,\"h\":810}";
                console.log(v);
                var buff = Buffer.from(v);
                var base64data = buff.toString('base64');
                console.log(base64data);
                buff = Buffer.from(base64data, 'base64');
                let text = buff.toString('ascii');
                console.log(text);
                var options = {
                    hostname: 'www.littlefox.com',
                    path: '/en/player_h5/view',
                    method: 'GET',
                    headers: {
                        "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
                        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
                        "cache-control": "no-cache",
                        "pragma": "no-cache",
                        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
                        "sec-ch-ua-mobile": "?0",
                        "sec-fetch-dest": "document",
                        "sec-fetch-mode": "navigate",
                        "sec-fetch-site": "none",
                        "sec-fetch-user": "?1",
                        "upgrade-insecure-requests": "1",
                        "cookie": "PHPSESSID=uj7bl0at8jkm5llhpkoo508ik6; h5play_info=" + base64data + "; _ga=GA1.2.2097850282.1631243843; _gid=GA1.2.1499091484.1631243843; _gat=1"
                    }
                };
                ops.push(options);
            }
            var count = 0;
            for (i in ops) {
                // console.log(ops[i]);
                var req = https.request(ops[i], function (res) {
                    var result = '';
                    res.on('data', function (chunk) {
                        result = result + chunk;
                    });
                    res.on('end', function () {
                        // console.log(results);
                        // console.log(options);
                        // console.log(i);
                        var contents = getVal(result, "var contents_info = ", "if (typeof contents_info[0].fc_id").trim();
                        // console.log(contents);
                        resData.push(contents);
                        count++;
                        if (count == ops.length) {
                            for (xd of resData) {
                                var vid = getVal(xd, "\"fc_id\":", ",\"cont_step_no\"");
                                var nextId = getVal(xd, "\"next_fc_id\":", ",\"ebook\"");
                                console.log(vid);
                                vid = vid.toString().replace(/\"/g, "");
                                nextId = nextId.replace(/\"/g, "");
                                xd = xd.replace("\"charge\":\"Y\"", "\"charge\":\"F\"");
                                mapId[nextId] = vid;
                                mapContentId[vid] = xd.substr(1,xd.length-3);
                            }

                            console.log(mapId);
                            var key = '';
                            var z = null;
                            z = mapId[key];
                            if (z == null) key = null;
                            var ll = [];
                            var i = 0;
                            while ((z = mapId[key]) != null) {
                                key = z;
                                ll[i++] = key;
                            }
                            // console.log(ll);
                            i = ll.length;
                            var summary = "";
                            for (i = ll.length - 1; i >= 0; i--) {
                                var e = ll[i] + " " + mapContentId[ll[i]] ;
                                console.log(e);
                            }

                        }
                    });
                });

                req.on('error', function (e) {
                    //TODO
                });

                req.end();
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
                // res.setHeader('Content-type', map[ext] || 'text/plain');
                res.writeHead(200, {
                    'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                    'Content-Type': map[ext] || 'text/plain'
                  });
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
                        // res.setHeader('Content-type', map[ext] || 'text/plain');
                        res.writeHead(200, {
                            'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                            'Content-Type': map[ext] || 'text/plain'
                          });
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


function getVal(x, t1, t2) {
    var val = x.substr(x.indexOf(t1) + t1.length, x.indexOf(t2) - x.indexOf(t1) - t1.length);
    return val;
}
