const http = require("http");
const https = require('https');
var util = require('util');
const fs = require('fs');
const host = 'localhost';
const port = 8000;
const path = require('path');
const url = require('url');
const mapCache = {};
var mapRes = {};
const jsdom = require("jsdom");
var playerText = null;

const log4js = require("log4js");
log4js.configure({
  appenders: { cheese: { type: "file", filename: "cheese.log" },console: { type: "console" }  },
  categories: { default: { appenders: ["cheese","console"], level: "info" } }
});
const logger = log4js.getLogger("cheese");

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
    // console.log(req.socket.remoteAddress);
    logger.info(req.url);
    var urld = decodeURI(req.url);
    const parsedUrl = url.parse(req.url);
    // extract URL path
    let pathname = `.${parsedUrl.pathname}`;
    // based on the URL path, extract the file extention. e.g. .js, .doc, ...
    const ext = path.parse(pathname).ext;
    // console.log(parsedUrl);
    // console.log(req.url);
    if (urld.indexOf('/littlefox/player/story=') >= 0) {
        console.log(urld);
      
        var storyId = "";
        var videoId = "";
        var idx = "";
        var tmp = urld.substr(urld.indexOf("player/story=") + "player/story=".length);
        if (tmp.indexOf("?") > 0) {
            storyId = tmp.substr(0, tmp.indexOf("?"));
        } else {
            storyId = tmp;
        }
        if (tmp.indexOf('idx=') >= 0) {
            var length = (tmp.indexOf('&', tmp.indexOf('idx=')) == -1 ?
                tmp.length : tmp.indexOf('&', tmp.indexOf('idx='))) - tmp.indexOf('idx=') - 'idx='.length;
            idx = tmp.substr(tmp.indexOf('idx=') + 'idx='.length, length);
        }
        if (tmp.indexOf('id=') >= 0) {
            length = (tmp.indexOf('&', tmp.indexOf('id=')) == -1 ? tmp.length : tmp.indexOf('&', tmp.indexOf('id='))) - tmp.indexOf('id=') - 'id='.length;
            videoId = tmp.substr(tmp.indexOf('id=') + 'id='.length, length);
        }
        // console.log(tmp);
        console.log('storyId:' + storyId);
        // console.log('idx:' + idx);
        // console.log('videoId:' + videoId);


        if (mapRes[storyId] != null) {
            // if the file is found, set Content-type and send data
            // res.setHeader('Content-type', map[ext] || 'text/plain');

            res.writeHead(200, {
                'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                'Content-Type': 'text/html',
            });
            var data = playerText;
            var contentsA = mapRes[storyId];
            var contents = '';
            var ix = 0;
            if (idx != "") {
                ix = Number(idx);
            }
            console.log("start index " + ix);
            for (i in contentsA) {
                if (ix > 0 && Number(i) + 1 >= ix) {
                    // console.log(i + " " + ix + " " + contentsA[i]);
                    contents += contentsA[i] + ',';
                } else if (ix == 0) {
                    contents += contentsA[i] + ',';
                }
            }

            contents = contents.substr(0, contents.length - 1);
            // console.log(contents);
            data = data.toString().replace('XXXXXXXXXXXXXXXXXXXXXXXX', contents);
            // console.log(data);

            res.end(data);
            return;
        }

        var turl = "https://www.littlefox.com/en/readers/contents_list/" + storyId;
        var xc = getScript(turl);
        var resData = [];
        var ops = [];
        var mapId = {};
        var mapContentId = {};
        var contentArrays = [];

        var end = new Promise((resolve, reject) => {
            xc.then(data => {
                // console.log(data)
                // res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
                // res.end(data);
                const dom = new jsdom.JSDOM(data.toString());
                var a = dom.window.document.querySelectorAll('tr[data-fcid]');
                for (let i of a) {
                    // console.log("============" + i.getAttribute("data-fcid"));
                    x = i.getAttribute("data-fcid");
                    // x1=x.substr("javascript:Player.view(".length,x.length);
                    // //console.log(x1);
                    // x1=x1.substr(0,x1.indexOf(","));
                    x1 = x;
                    x1 = x1.replace(/\"/g, "");
                    console.log(x1);
                    //base64_encode("{\"fc_ids\":\"C0007022\",\"w\":1288,\"h\":810}")
                    v = "{\"fc_ids\":\"" + x1 + "\",\"w\":1288,\"h\":810}";
                    // console.log(v);
                    var buff = Buffer.from(v);
                    var base64data = buff.toString('base64');
                    // console.log(base64data);
                    buff = Buffer.from(base64data, 'base64');
                    let text = buff.toString('ascii');
                    // console.log(text);
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
                    var reqX = https.request(ops[i], function (resX) {
                        var result = '';
                        resX.on('data', function (chunk) {
                            result = result + chunk;
                        });
                        resX.on('end', function () {
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
                                    // console.log(vid);
                                    vid = vid.toString().replace(/\"/g, "");
                                    nextId = nextId.replace(/\"/g, "");
                                    xd = xd.replace("\"charge\":\"Y\"", "\"charge\":\"F\"");
                                    mapId[nextId] = vid;
                                    mapContentId[vid] = xd.substr(1, xd.length - 3);
                                }

                                // console.log(mapId);
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
                                var contents = '';
                                for (i = ll.length - 1; i >= 0; i--) {
                                    var e = ll[i] + " " + mapContentId[ll[i]];
                                    // console.log(e);
                                    contents += mapContentId[ll[i]] + ',';
                                    contentArrays.push(mapContentId[ll[i]]);
                                }

                                contents = contents.substr(0, contents.length - 1);

                                resolve(contentArrays);

                            }
                        });
                    });

                    reqX.on('error', function (e) {
                        //TODO
                    });


                    reqX.end();


                }


            });
        });

        end.then(

            contentsA => {

                fs.readFile(__dirname + '/player.html', function (err, data) {
                    if (err) {
                        res.statusCode = 500;
                        res.end(`Error getting the file: ${err}.`);
                    } else {
                        // if the file is found, set Content-type and send data
                        // res.setHeader('Content-type', map[ext] || 'text/plain');

                        if(playerText == null){
                            playerText = data;
                        }

                        mapRes[storyId] = contentsA;

                        res.writeHead(200, {
                            'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                            'Content-Type': 'text/html',
                        });

                        var contents = '';
                        var ix = 0;
                        if (idx != "") {
                            ix = Number(idx);
                        }
                        console.log("start index " + ix);
                        for (i in contentsA) {
                            if (ix > 0 && Number(i) + 1 >= ix) {
                                // console.log(i + " " + ix + " " + contentsA[i]);
                                contents += contentsA[i] + ',';
                            } else if (ix == 0) {
                                contents += contentsA[i] + ',';
                            }
                        }

                        contents = contents.substr(0, contents.length - 1);
                        // console.log(contents);
                        data = data.toString().replace('XXXXXXXXXXXXXXXXXXXXXXXX', contents);
                        // console.log(data);

                        res.end(data);
                        // mapCache[urld] = data;
                    }
                });
            }
        );
        return;
    }


    var cookies = parseCookies(req);
    switch (cookies['root']) {
        case '/littlefox':
        case "littlefox":
            var turl = "";
            if (urld != "/littlefox") {
                fs.exists(__dirname + urld, function (exists) {
                    if (!exists) {
                        turl = "https://www.littlefox.com/" + urld;
                        var x = getScript(turl);
                        x.then(data => {
                            // console.log(data)
                            res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
                            res.end(data);
                        });
                        return;
                    }

                    if (mapCache[urld] != null) {
                        // res.setHeader('Content-type', map[ext] || 'text/plain');
                        if (urld == "/player.html") {
                            res.writeHead(200, {
                                'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                                'Content-Type': map[ext] || 'text/plain'
                            });
                        } else {
                            res.setHeader('Content-type', map[ext] || 'text/plain');
                        }
                        res.end(mapCache[urld]);
                        // console.log("Return");                  
                        return;
                    }
                    fs.readFile(__dirname + urld, function (err, data) {
                        if (err) {
                            res.statusCode = 500;
                            res.end(`Error getting the file: ${err}.`);
                        } else {
                            // if the file is found, set Content-type and send data
                            // res.setHeader('Content-type', map[ext] || 'text/plain');
                            if (urld == "/player.html") {
                                res.writeHead(200, {
                                    'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                                    'Content-Type': map[ext] || 'text/plain'
                                });
                                data = data.toString().replace('XXXXXXXXXXXXXXXXXXXXXXXX', '{"fc_id":"C0007600","cont_step_no":"13409","fs_id":"FS0102","charge":"F","type":"S","content_level":"LV01","cont_name":"Dino Buddies 9","cont_sub_name":"The Egg","title_time":"9.288","video_url":"\/contents_5\/hls\/1080\/1dc8df3be5\/m2f81e0248\/4a852d555ec295ffa8a5c7596a2f30fa.m3u8?0517094831","purge_val":"","next_fc_id":"C0007601","ebook":"Y","quiz":"Y","crossword":"N","starwords":"Y","recorder":"Y","mp3download":"Y","printablebook":"Y","text":"Y","writing_topics":"N","flash_card":"N","with_mom":"N","topic":"N","tracing":"Y","worksheet":"N","paint":"N","flashcards":"Y","play_subtime":"0","play_time":"129.35","mod_date":"20190517094836"},{"fc_id":"C0007592","cont_step_no":"13401","fs_id":"FS0102","charge":"F","type":"S","content_level":"LV01","cont_name":"Dino Buddies 1","cont_sub_name":"The Park","title_time":"9.288","video_url":"\/contents_5\/hls\/1080\/fc797469c9\/m025d17513\/becb9d0a684eddf7ab309c7c14069fa8.m3u8?0517091304","purge_val":"","next_fc_id":"C0007593","ebook":"F","quiz":"F","crossword":"N","starwords":"Y","recorder":"Y","mp3download":"F","printablebook":"F","text":"F","writing_topics":"N","flash_card":"N","with_mom":"N","topic":"N","tracing":"F","worksheet":"N","paint":"N","flashcards":"F","play_subtime":"0","play_time":"140.89","mod_date":"20200903040254"}')
                                console.log(data);
                            } else {
                                res.setHeader('Content-type', map[ext] || 'text/plain');
                            }
                            res.end(data);
                            mapCache[urld] = data;
                        }
                    });
                });
            } else {
                turl = "https://www.littlefox.com/en";
                var x = getScript(turl);
                x.then(data => {
                    // console.log(data)
                    res.writeHead(200, { 'Content-type': 'text/html', 'Set-Cookie': 'root="littlefox"' });
                    res.end(data);
                });
            }
            return;
        default:
            console.log("Nothing ");
    }
    console.log("Come hear " + urld);

    switch (urld) {
        case "/littlefox":
        case "/littlefox/":
        case '/littlefox':
        case '/littlefox/':
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
                if (urld == "/player.html") {
                    res.writeHead(200, {
                        'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                        'Content-Type': map[ext] || 'text/plain'
                    });
                } else {
                    res.setHeader('Content-type', map[ext] || 'text/plain');
                }
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
                        if (urld == "/player.html") {
                            res.writeHead(200, {
                                'Set-Cookie': 'h5play_info=eyJmY19pZHMiOiJDMDAwMTI4NiIsInciOjEyODgsImgiOjgxMH0=',
                                'Content-Type': map[ext] || 'text/plain'
                            });
                            data = data.toString().replace('XXXXXXXXXXXXXXXXXXXXXXXX', '{"fc_id":"C0007600","cont_step_no":"13409","fs_id":"FS0102","charge":"F","type":"S","content_level":"LV01","cont_name":"Dino Buddies 9","cont_sub_name":"The Egg","title_time":"9.288","video_url":"\/contents_5\/hls\/1080\/1dc8df3be5\/m2f81e0248\/4a852d555ec295ffa8a5c7596a2f30fa.m3u8?0517094831","purge_val":"","next_fc_id":"C0007601","ebook":"Y","quiz":"Y","crossword":"N","starwords":"Y","recorder":"Y","mp3download":"Y","printablebook":"Y","text":"Y","writing_topics":"N","flash_card":"N","with_mom":"N","topic":"N","tracing":"Y","worksheet":"N","paint":"N","flashcards":"Y","play_subtime":"0","play_time":"129.35","mod_date":"20190517094836"},{"fc_id":"C0007592","cont_step_no":"13401","fs_id":"FS0102","charge":"F","type":"S","content_level":"LV01","cont_name":"Dino Buddies 1","cont_sub_name":"The Park","title_time":"9.288","video_url":"\/contents_5\/hls\/1080\/fc797469c9\/m025d17513\/becb9d0a684eddf7ab309c7c14069fa8.m3u8?0517091304","purge_val":"","next_fc_id":"C0007593","ebook":"F","quiz":"F","crossword":"N","starwords":"Y","recorder":"Y","mp3download":"F","printablebook":"F","text":"F","writing_topics":"N","flash_card":"N","with_mom":"N","topic":"N","tracing":"F","worksheet":"N","paint":"N","flashcards":"F","play_subtime":"0","play_time":"140.89","mod_date":"20200903040254"}')
                            console.log(data);
                        } else {
                            res.setHeader('Content-type', map[ext] || 'text/plain');
                        }
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
