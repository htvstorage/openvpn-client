// -*- coding: utf-8 -*-

// Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: LicenseRef-.amazon.com.-AmznSL-1.0
// Licensed under the Amazon Software License (the "License")
// You may not use this file except in compliance with the License.
// A copy of the License is located at http://aws.amazon.com/asl/
//
// This file is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific
// language governing permissions and limitations under the License.
const https = require('https')


exports.handler = async function (request, context) {
        log("DEBUG:", "Request",  JSON.stringify(request));    
    if (request.directive.header.namespace === 'Alexa.Discovery' && request.directive.header.name === 'Discover') {
        log("DEBUG:", "Discover request",  JSON.stringify(request));
        return handleDiscovery(request, context, "");
    }
    else if (request.directive.header.namespace === 'Alexa.PowerController') {
        if (request.directive.header.name === 'TurnOn' || request.directive.header.name === 'TurnOff') {
            log("DEBUG:", "TurnOn or TurnOff Request", JSON.stringify(request));
            handlePowerControl(request, context);
        }
    }
    else if (request.directive.header.namespace === 'Alexa.Authorization' && request.directive.header.name === 'AcceptGrant') {
        handleAuthorization(request, context)
    }

   async function handleDiscovery(request, context) {
        
        const data = JSON.stringify(request);
        
        
        // Send the discovery response
        const options = {
          hostname: '3001-htvstorage-openvpnclient-5tyasp6nzht.ws-us40.gitpod.io',
          port: 443,
          path: '/test',
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Content-Length': data.length
          }};
        var dataQueue = ""; 
        
          const promise = new Promise(function(resolve, reject) {
              
              
    // https.get(url, (res) => {
    //     resolve(res.statusCode)
    //   }).on('error', (e) => {
    //     reject(Error(e))
    //   })
      
      
      
        const req = https.request(options, res => {
          console.log(`statusCode: ${res.statusCode}`)
          // resolve(res.statusCode)        
          res.on('data', d => {
            dataQueue += d;
             process.stdout.write(d);
          })
          
          res.on('end',()=>{
            var header = request.directive.header;
            header.name = "Discover.Response";
            
            var payload = JSON.parse(dataQueue);
            log("DEBUG", "Discovery Response: ", JSON.stringify({ header: header, payload: payload }));
            context.succeed({ event: { header: header, payload: payload.event.payload } });   
            
            //  resolve({ event: { header: header, payload: payload.event.payload } })        
            resolve(res.statusCode) 
          });
        }).on('error', (e) => {
        reject(Error(e))
      })
        
        
        req.on('error', error => {
          console.error(error)
        })
        
        req.write(data)
        req.end();      
      
    });
    

    return promise    

    }

    function log(message, message1, message2) {
        console.log(message + message1 + message2);
    }

    async function handlePowerControl(request, context) {
        
        
        
             const data = JSON.stringify(request);
        
        
        // Send the discovery response
        const options = {
          hostname: '3001-htvstorage-openvpnclient-5tyasp6nzht.ws-us40.gitpod.io',
          port: 443,
          path: '/test',
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Content-Length': data.length
          }};
        var dataQueue = ""; 
        
          const promise = new Promise(function(resolve, reject) {
              
              
    // https.get(url, (res) => {
    //     resolve(res.statusCode)
    //   }).on('error', (e) => {
    //     reject(Error(e))
    //   })
      
      
      
        const req = https.request(options, res => {
          console.log(`statusCode: ${res.statusCode}`)
          // resolve(res.statusCode)        
          res.on('data', d => {
            dataQueue += d;
             process.stdout.write(d);
          })
          
          res.on('end',()=>{
            var header = request.directive.header;
            header.name = "Discover.Response";
            
            var payload = JSON.parse(dataQueue);
            log("DEBUG", "Discovery Response: ", JSON.stringify({ header: header, payload: payload }));
            context.succeed({ event: { header: header, payload: payload.event.payload } });   
            
            //  resolve({ event: { header: header, payload: payload.event.payload } })        
            resolve(res.statusCode) 
          });
        }).on('error', (e) => {
        reject(Error(e))
      })
        
        
        req.on('error', error => {
          console.error(error)
        })
        
        req.write(data)
        req.end();      
      
    });
    
        // get device ID passed in during discovery
        var requestMethod = request.directive.header.name;
        var responseHeader = request.directive.header;
        responseHeader.namespace = "Alexa";
        responseHeader.name = "Response";
        responseHeader.messageId = responseHeader.messageId + "-R";
        // get user token pass in request
        var requestToken = request.directive.endpoint.scope.token;
        var powerResult;

        if (requestMethod === "TurnOn") {

            // Make the call to your device cloud for control
            // powerResult = stubControlFunctionToYourCloud(endpointId, token, request);
            powerResult = "ON";
        }
       else if (requestMethod === "TurnOff") {
            // Make the call to your device cloud for control and check for success
            // powerResult = stubControlFunctionToYourCloud(endpointId, token, request);
            powerResult = "OFF";
        }
        // Return the updated powerState.  Always include EndpointHealth in your Alexa.Response
        var contextResult = {
            "properties": [{
                "namespace": "Alexa.PowerController",
                "name": "powerState",
                "value": powerResult,
                "timeOfSample": "2017-09-03T16:20:50.52Z", //retrieve from result.
                "uncertaintyInMilliseconds": 50
            },
            {
                "namespace": "Alexa.EndpointHealth",
                "name": "connectivity",
                "value": {
                "value": "OK"
            },
            "timeOfSample": "2022-03-09T22:43:17.877738+00:00",
            "uncertaintyInMilliseconds": 0
            }]
        };
        var response = {
            context: contextResult,
            event: {
                header: responseHeader,
                endpoint: {
                    scope: {
                        type: "BearerToken",
                        token: requestToken
                    },
                    endpointId: "sample-bulb-01"
                },
                payload: {}
            }
        };
        log("DEBUG", "Alexa.PowerController ", JSON.stringify(response));
        context.succeed(response);
        
            return promise  
    }
};
