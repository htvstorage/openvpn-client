const express = require('express');
const alexa = require('../index');

const PORT = process.env.port || 3001;
const bodyParser = require('body-parser')
const app = express().use(bodyParser.json());


//const bodyParser = require('body-parser')

// ... app code here

//const expressApp = express2().use(bodyParser.json())
// let demoLogger = (req, res, next) => {
//   console.error('Intercepting requests ...',req.url);
//   console.error('Intercepting requests ...',req.query);
//   console.error('Intercepting body ...',req.body);
//   console.error('Intercepting header ...',req.headers);
//   next();  // call next() here to move on to next middleware/router
// };
// expressApp.use(demoLogger);

app.all('/*', function(req, res, next) {
 console.error('Intercepting requests ...',req.url);
 console.error('Intercepting requests ...',req.query);
 console.error('Intercepting body ...',JSON.stringify(req.body));
 console.error('Intercepting header ...',req.headers);
 next();  // call next() here to move on to next middleware/router
});

// app.all('/test*', function(request, response) {
//    console.error('Intercepting requests ...',request.url);
//   console.log('Intercepting requests ...',request.query);
//   console.log('Intercepting body ...',request.body);
//   console.log('Intercepting header ...',request.headers);

  

//   // const grantType = request.query.grant_type ?
//   //   request.query.grant_type : request.body.grant_type;
//   // const secondsInDay = 86400; // 60 * 60 * 24
//   const HTTP_STATUS_OK = 200;
//   // console.log(`Grant type ${grantType}`);

//   let obj;
//   obj = {
//     endpointId: 'uniqueIdOfCameraEndpoint',
//     manufacturerName: 'the manufacturer name of the endpoint',
//     modelName: 'the model name of the endpoint',
//     friendlyName: 'Camera',
//     description: 'a description that is shown to the customer',
//     displayCategories: ['CAMERA'],
//     cookie: {
//       key1: 'arbitrary key/value pairs for skill to reference this endpoint.',
//       key2: 'There can be multiple entries',
//       key3: 'but they should only be used for reference purposes.',
//       key4: 'This is not a suitable place to maintain current endpoint state.',
//     },
//     capabilities: [{
//       type: 'AlexaInterface',
//       interface: 'Alexa.CameraStreamController',
//       version: '3',
//       cameraStreamConfigurations: [
//         {
//           protocols: ['RTSP'],
//           resolutions: [{ width: 1920, height: 1080 }, { width: 1280, height: 720 }],
//           authorizationTypes: ['BASIC'],
//           videoCodecs: ['H264', 'MPEG2'],
//           audioCodecs: ['G711'],
//         },
//         {
//           protocols: ['RTSP'],
//           resolutions: [{ width: 1920, height: 1080 }, { width: 1280, height: 720 }],
//           authorizationTypes: ['NONE'],
//           videoCodecs: ['H264'],
//           audioCodecs: ['AAC'],
//         },
//       ],
//     }],
//   };
//   response.status(HTTP_STATUS_OK)
//       .json(obj);

// });
// ALWAYS setup the alexa app and attach it to express before anything else.
const endpoint = 'test';
const alexaApp = new alexa.app(endpoint);

alexaApp.express({
 expressApp: app,
 checkCert: false,
 debug: true
});

app.set('view engine', 'ejs');

alexaApp.discovery((request, response) => {
  console.error('Discovery==============================');
  response.endpoint(
    {
        "endpointId": "sample-bulb-05",
        "manufacturerName": "Smart Device Company",
        "friendlyName": "Livingroom lamp",
        "description": "Virtual smart light bulb",
        "displayCategories": ["LIGHT"],
        "additionalAttributes":  {
            "manufacturer" : "Sample Manufacturer",
            "model" : "Sample Model",
            "serialNumber": "U11112233456",
            "firmwareVersion" : "1.24.2546",
            "softwareVersion": "1.036",
            "customIdentifier": "Sample custom ID"
        },
        "cookie": {
            "key1": "arbitrary key/value pairs for skill to reference this endpoint.",
            "key2": "There can be multiple entries",
            "key3": "but they should only be used for reference purposes.",
            "key4": "This is not a suitable place to maintain current endpoint state."
        },
        "capabilities":
        [
            {
                "interface": "Alexa.PowerController",
                "version": "3",
                "type": "AlexaInterface",
                "properties": {
                    "supported": [{
                        "name": "powerState"
                    }],
                     "retrievable": true
                }
            },
            {
            "type": "AlexaInterface",
            "interface": "Alexa.EndpointHealth",
            "version": "3.2",
            "properties": {
                "supported": [{
                    "name": "connectivity"
                }],
                "retrievable": true
            }
        },
        {
            "type": "AlexaInterface",
            "interface": "Alexa",
            "version": "3"
        }
        ]
    }   
);
});

alexaApp.cameraStreamController((request, response) => {
    console.error('CameraController==============================');

  response.cameraStream({
    uri: 'rtsp://username:password@link.to.video:443/feed1.mp4',
    expirationTime: '2017-09-27T20:30:30.45Z',
    idleTimeoutSeconds: 30,
    protocol: 'RTSP',
    resolution: {
      width: 1920,
      height: 1080,
    },
    authorizationType: 'BASIC',
    videoCodec: 'H264',
    audioCodec: 'AAC',
  });
});



app.listen(PORT);
console.log(`Listening on port ${PORT}, try http://localhost:${PORT}/${endpoint}`);

