/**
 * EventHandler
 *
 * Copyright (c) 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
@RestResource(urlMapping='/events/*')
global with sharing class EventHandler {
    @HttpPut
    global static String doPut() {
        // get our configuration and reload it...
        ConfigurationController.Configuration config = new ConfigurationController.Configuration(true);
        
        // get the device server
        ConfigurationController.DeviceServer ds = new ConfigurationController.DeviceServer(config);
        
        // first, validate the request, then process it
        if (ds.notificationValidated(RestContext.request)) {
            // get the request body and decode it...
            String jsonstring = null;
            try {
	            Blob b = RestContext.request.requestBody;
	            String jsonstring_utf_8 = b.toString();
	            jsonstring = EncodingUtil.urlDecode(jsonstring_utf_8, 'UTF-8');
	            		
        		// process the request
    			return ds.processNotification(jsonstring);
            }
            catch (Exception ex) {
            	ds.restDebug('doPut: exception: ' + ex.getMessage());
            }
        }
        return 'FAIL';
        
    }
}