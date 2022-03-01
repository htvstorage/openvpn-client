var http = require('https');
var fs = require('fs');
var multiparty = require('multiparty');
var status = 0;
var util = require('util');

var rootdir = "./";
var numberUpload = 1;


var server = http.createServer({
  key: fs.readFileSync('private.key'),
  cert: fs.readFileSync('certificate.crt'),
  ca: fs.readFileSync('ca_bundle.crt')
},function (request, response) {
  response.writeHead(200);
  console.log(request);
  if (request.method === 'GET') {
    //console.log(request);
    if (request.url === '/checkstatus') {
      response.end(status.toString());
      return;
    }
    fs.createReadStream('filechooser.html').pipe(response);
  }
  else if (request.method === 'POST') {
    // console.log(request);
    // var form = request.form;
    //console.log(request);

    var form = new multiparty.Form();
    var fileName = null;


    status = 0;
    console.log('file name' + fileName);
    // var outputFile = fs.createWriteStream('fileName');
    var total = request.headers['content-length'];
    var progress = 0;
    var str = '';
    request.on('data', function (chunk) {
      // console.log(chunk);
      progress += chunk.length;
      str += chunk;
      var perc = parseInt((progress / total) * 100);
      console.log('percent complete: ' + perc + '%\n');
      status = perc;
    });

    // request.pipe(outputFile);

    form.parse(request, function (err, fields, files) {
      //   res.writeHead(200, { 'content-type': 'text/plain' });
      //   res.write('received upload:\n\n');
      //   res.end(util.inspect({ fields: fields, files: files }));
      console.log(files);
      // console.log(util.inspect(files));
      // console.log(Object.keys(files));
       if(files != null){
      var keys = Object.keys(files);
      // console.log(fields);
      // fileName = files['upload'][0]['originalFilename'];
      // if(files.keys());
      for (let f of keys) {
        for (let e of files[f]) {
          if (e['size'] > 0) {
            fs.copyFile(e['path'], e['originalFilename'], function (err) {
              if (err) throw err;
              // res.write('File uploaded and moved!');
              // res.end();
              console.log("Uploaded: " + e['originalFilename']);
            });
          }
        }
      }
      }
    });


    request.on('end', function () {

      console.log(str);

      response.end('\nArchived File\n\n');
    });
  }

});

server.listen(1700, function () {
  console.log('Server is listening on 1700');
});


function getMethods(obj) {
  var result = [];
  for (var id in obj) {
    try {
      if (typeof (obj[id]) == "function") {
        result.push(id + ": " + obj[id].toString());
      }
    } catch (err) {
      result.push(id + ": inaccessible");
    }
  }
  return result;
}
