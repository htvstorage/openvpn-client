/**
 * Copyright 2018 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

const functions = require('firebase-functions');
const {smarthome} = require('actions-on-google');
const {google} = require('googleapis');
const util = require('util');
const admin = require('firebase-admin');
// Initialize Firebase
admin.initializeApp();
//const firebaseRef = admin.database().ref('/');
// Initialize Homegraph
const auth = new google.auth.GoogleAuth({
  scopes: ['https://www.googleapis.com/auth/homegraph'],
});
const homegraph = google.homegraph({
  version: 'v1',
  auth: auth,
});
// Hardcoded user ID
const USER_ID = '123';

var http = require('http');
var express = require('express');
var eapp = express();
eapp.use(express.json())
eapp.use(express.urlencoded({extended: true}))

// exports.login = functions.https.onRequest((request, response) => {
//   if (request.method === 'GET') {
//     functions.logger.log('Requesting login page');
//     response.send(`
//     <html>
//       <meta name="viewport" content="width=device-width, initial-scale=1">
//       <body>
//         <form action="/login" method="post">
//           <input type="hidden"
//             name="responseurl" value="${request.query.responseurl}" />
//           <button type="submit" style="font-size:14pt">
//             Link this service to Google
//           </button>
//         </form>
//       </body>
//     </html>
//   `);
//   } else if (request.method === 'POST') {
//     // Here, you should validate the user account.
//     // In this sample, we do not do that.
//     const responseurl = decodeURIComponent(request.body.responseurl);
//     functions.logger.log(`Redirect to ${responseurl}`);
//     return response.redirect(responseurl);
//   } else {
//     // Unsupported method
//     response.send(405, 'Method Not Allowed');
//   }
// });

eapp.all('/login*', function(request, response) {
  console.log('Intercepting requests ...',request.query);
  console.log('Intercepting body ...',request.body);
  console.log('Intercepting header ...',request.headers);

  if (request.method === 'GET') {
    console.log('Requesting login page');
    response.send(`
    <html>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <body>
        <form action="/login" method="post">
          <input type="hidden"
            name="responseurl" value="${request.query.responseurl}" />
          <button type="submit" style="font-size:14pt">
            Link this service to Google
          </button>
        </form>
      </body>
    </html>
  `);
  } else if (request.method === 'POST') {
    // Here, you should validate the user account.
    // In this sample, we do not do that.
    const responseurl = decodeURIComponent(request.body.responseurl);
    console.log(`Redirect to ${responseurl}`);
    return response.redirect(responseurl);
  } else {
    // Unsupported method
    response.send(405, 'Method Not Allowed');
  }

});



// exports.fakeauth = functions.https.onRequest((request, response) => {
//   const responseurl = util.format('%s?code=%s&state=%s',
//       decodeURIComponent(request.query.redirect_uri), 'xxxxxx',
//       request.query.state);
//   functions.logger.log(`Set redirect as ${responseurl}`);
//   return response.redirect(
//       `/login?responseurl=${encodeURIComponent(responseurl)}`);
// });


eapp.all('/fakeauth*', function(request, response) {
  console.log('Intercepting requests ...',request.query);
  console.log('Intercepting body ...',request.body);
  console.log('Intercepting header ...',request.headers);

  const responseurl = util.format('%s?code=%s&state=%s',
  decodeURIComponent(request.query.redirect_uri), 'xxxxxx',
  request.query.state);
  console.log(`Set redirect as ${responseurl}`);
return response.redirect(
  `/login?responseurl=${encodeURIComponent(responseurl)}`);

});
// exports.faketoken = functions.https.onRequest((request, response) => {
//   const grantType = request.query.grant_type ?
//     request.query.grant_type : request.body.grant_type;
//   const secondsInDay = 86400; // 60 * 60 * 24
//   const HTTP_STATUS_OK = 200;
//   functions.logger.log(`Grant type ${grantType}`);

//   let obj;
//   if (grantType === 'authorization_code') {
//     obj = {
//       token_type: 'bearer',
//       access_token: '123access',
//       refresh_token: '123refresh',
//       expires_in: secondsInDay,
//     };
//   } else if (grantType === 'refresh_token') {
//     obj = {
//       token_type: 'bearer',
//       access_token: '123access',
//       expires_in: secondsInDay,
//     };
//   }
//   response.status(HTTP_STATUS_OK)
//       .json(obj);
// });


eapp.all('/faketoken*', function(request, response) {
  console.log('Intercepting requests ...',request.query);
  console.log('Intercepting body ...',request.body);
  console.log('Intercepting header ...',request.headers);

  const grantType = request.query.grant_type ?
    request.query.grant_type : request.body.grant_type;
  const secondsInDay = 86400; // 60 * 60 * 24
  const HTTP_STATUS_OK = 200;
  console.log(`Grant type ${grantType}`);

  let obj;
  if (grantType === 'authorization_code') {
    obj = {
      token_type: 'bearer',
      access_token: '123access',
      refresh_token: '123refresh',
      expires_in: secondsInDay,
    };
  } else if (grantType === 'refresh_token') {
    obj = {
      token_type: 'bearer',
      access_token: '123access',
      expires_in: secondsInDay,
    };
  }
  response.status(HTTP_STATUS_OK)
      .json(obj);

});



const app = smarthome();

app.onSync((body) => {
  return {
    requestId: body.requestId,
    payload: {
      agentUserId: USER_ID,
      devices: [{
        id: 'washer',
        type: 'action.devices.types.WASHER',
        traits: [
          'action.devices.traits.OnOff',
          'action.devices.traits.StartStop',
          'action.devices.traits.RunCycle',
        ],
        name: {
          defaultNames: ['My Washer'],
          name: 'Washer',
          nicknames: ['Washer'],
        },
        deviceInfo: {
          manufacturer: 'Acme Co',
          model: 'acme-washer',
          hwVersion: '1.0',
          swVersion: '1.0.1',
        },
        willReportState: true,
        attributes: {
          pausable: true,
        },
      }],
    },
  };
});

var storeState = { on: true,
  isPaused: false,
  isRunning: false
};


const queryFirebase = async (deviceId) => {
  // const snapshot = await firebaseRef.child(deviceId).once('value');
  // const snapshotVal = snapshot.val();
  console.log("deviceId--", deviceId);
  return {
    on: storeState.on,
    isPaused: storeState.isPaused,
    isRunning: storeState.isRunning,
  };
};
const queryDevice = async (deviceId) => {
  const data = await queryFirebase(deviceId);
  return {
    on: data.on,
    isPaused: data.isPaused,
    isRunning: data.isRunning,
    currentRunCycle: [{
      currentCycle: 'rinse',
      nextCycle: 'spin',
      lang: 'en',
    }],
    currentTotalRemainingTime: 1212,
    currentCycleRemainingTime: 301,
  };
};

app.onQuery(async (body) => {
  const {requestId} = body;
  const payload = {
    devices: {},
  };
  const queryPromises = [];
  const intent = body.inputs[0];
  for (const device of intent.payload.devices) {
    const deviceId = device.id;
    queryPromises.push(
        queryDevice(deviceId)
            .then((data) => {
              // Add response to device payload
              payload.devices[deviceId] = data;
            }) );
  }
  // Wait for all promises to resolve
  await Promise.all(queryPromises);
  return {
    requestId: requestId,
    payload: payload,
  };
});

const updateDevice = async (execution, deviceId) => {
  const {params, command} = execution;
  let state; let ref;
  switch (command) {
    case 'action.devices.commands.OnOff':
      state = {on: params.on};
      //ref = firebaseRef.child(deviceId).child('OnOff');
      storeState.on = state.on;
      break;
    case 'action.devices.commands.StartStop':
      state = {isRunning: params.start};
      //ref = firebaseRef.child(deviceId).child('StartStop');
      storeState.isRunning = state.isRunning;
      break;
    case 'action.devices.commands.PauseUnpause':
      state = {isPaused: params.pause};
      //ref = firebaseRef.child(deviceId).child('StartStop');
      storeState.isPaused = state.isPaused;
      break;
  }

  // return ref.update(state)
  //     .then(() => state);
  return state;
};

app.onExecute(async (body) => {
  const {requestId} = body;
  // Execution results are grouped by status
  const result = {
    ids: [],
    status: 'SUCCESS',
    states: {
      online: true,
    },
  };

  const executePromises = [];
  const intent = body.inputs[0];
  for (const command of intent.payload.commands) {
    for (const device of command.devices) {
      for (const execution of command.execution) {
        executePromises.push(
            updateDevice(execution, device.id)
                .then((data) => {
                  result.ids.push(device.id);
                  Object.assign(result.states, data);
                })
                .catch(() => console.error('EXECUTE', device.id)));
      }
    }
  }

  await Promise.all(executePromises);
  return {
    requestId: requestId,
    payload: {
      commands: [result],
    },
  };
});

app.onDisconnect((body, headers) => {
  console.log('User account unlinked from Google Assistant');
  // Return empty response
  return {};
});

// exports.smarthome = functions.https.onRequest(app);

// exports.requestsync = functions.https.onRequest(async (request, response) => {
//   response.set('Access-Control-Allow-Origin', '*');
//   functions.logger.info(`Request SYNC for user ${USER_ID}`);
//   try {
//     const res = await homegraph.devices.requestSync({
//       requestBody: {
//         agentUserId: USER_ID,
//       },
//     });
//     functions.logger.info('Request sync response:', res.status, res.data);
//     response.json(res.data);
//   } catch (err) {
//     functions.logger.error(err);
//     response.status(500).send(`Error requesting sync: ${err}`);
//   }
// });

eapp.all('/requestsync*', async function(request, response) {
  response.set('Access-Control-Allow-Origin', '*');
  console.info(`Request SYNC for user ${USER_ID}`);
  try {
    const res = await homegraph.devices.requestSync({
      requestBody: {
        agentUserId: USER_ID,
      },
    });
    console.info('Request sync response:', res.status, res.data);
    response.json(res.data);
  } catch (err) {
    console.error(err);
    response.status(500).send(`Error requesting sync: ${err}`);
  }
});

eapp.all('/*', function(req, res, next) {
  console.error('Intercepting requests ...',req.query);
  console.error('Intercepting body ...',req.body);
  console.error('Intercepting header ...',req.headers);
  next();  // call next() here to move on to next middleware/router
});

var httpServer = http.createServer(eapp);
httpServer.listen(8080);




const express2 = require('express')
const bodyParser = require('body-parser')

// ... app code here

const expressApp = express2().use(bodyParser.json())
// let demoLogger = (req, res, next) => { 
//   console.error('Intercepting requests ...',req.url);
//   console.error('Intercepting requests ...',req.query);
//   console.error('Intercepting body ...',req.body);
//   console.error('Intercepting header ...',req.headers);
//   next();  // call next() here to move on to next middleware/router  
// };
// expressApp.use(demoLogger);

expressApp.all('/*', function(req, res, next) {
  console.error('Intercepting requests ...',req.url);
  console.error('Intercepting requests ...',req.query);
  console.error('Intercepting body ...',JSON.stringify(req.body));
  console.error('Intercepting header ...',req.headers);
  next();  // call next() here to move on to next middleware/router
});

expressApp.post('/fulfillment', app)



expressApp.listen(3000)

/**
 * Send a REPORT STATE call to the homegraph when data for any device id
 * has been changed.
 */
// exports.reportstate = functions.database.ref('{deviceId}').onWrite(
//     async (change, context) => {
//       functions.logger.info('Firebase write event triggered Report State');
//       const snapshot = change.after.val();

//       const requestBody = {
//         requestId: 'ff36a3cc', /* Any unique ID */
//         agentUserId: USER_ID,
//         payload: {
//           devices: {
//             states: {
//               /* Report the current state of our washer */
//               [context.params.deviceId]: {
//                 on: snapshot.OnOff.on,
//                 isPaused: snapshot.StartStop.isPaused,
//                 isRunning: snapshot.StartStop.isRunning,
//               },
//             },
//           },
//         },
//       };

//       const res = await homegraph.devices.reportStateAndNotification({
//         requestBody,
//       });
//       functions.logger.info('Report state response:', res.status, res.data);
//     });

