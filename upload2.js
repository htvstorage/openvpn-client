var http = require('http');
var fs = require('fs');
var multiparty = require('multiparty');
var status = 0;
var util = require('util');

var rootdir = "./";
var numberUpload = 1;


var server = http.createServer(function (request, response) {
  response.writeHead(200);
  if (request.method === 'GET') {
    if (request.url === '/checkstatus') {
      response.end(status.toString());
      return;
    }
    fs.createReadStream('filechooser.html').pipe(response);
  }
  else if (request.method === 'POST') {
    // console.log(request);
    // var form = request.form;
    console.log(request);

    var form = new multiparty.Form();
    var fileName = null;


    status = 0;
    console.log('file name' + fileName);
    // var outputFile = fs.createWriteStream('fileName');
    var total = request.headers['content-length'];
    var progress = 0;

    request.on('data', function (chunk) {
      // console.log(chunk);
      progress += chunk.length;
      var perc = parseInt((progress / total) * 100);
      console.log('percent complete: ' + perc + '%\n');
      status = perc;
    });

    // request.pipe(outputFile);

    form.parse(request, function (err, fields, files) {
      try{
      //   res.writeHead(200, { 'content-type': 'text/plain' });
      //   res.write('received upload:\n\n');
      //   res.end(util.inspect({ fields: fields, files: files }));
      console.log(files);
      // console.log(util.inspect(files));
      // console.log(Object.keys(files));
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
    
    }catch(error){
      console.log(error);
    }
    });


    request.on('end', function () {



      response.end('\nArchived File\n\n');
    });
  }

});

server.listen(8081, function () {
  console.log('Server is listening on 8080');
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