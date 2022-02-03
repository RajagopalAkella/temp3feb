/**
 * MapViewController
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
public with sharing class MapViewController {
    
    // Location Wrapper for JSON deserialization
    public class LocationWrapper {
        public string latitude;
        public string longitude;
        public string msl;
        public string speed;
    }
    
    public String endpoint {get; set; }
    public String uri {get; set; }
    public String payload { get; set; }
    public String latitude { get; set; }
    public String longitude { get; set; }
    public String altitude { get; set; }
    public String speed { get; set; }
    
    public MapViewController() {
        this.RefreshResourceValues();
    }
    
    public void RefreshResourceValues() {
        this.initValues();
        this.initLocation();
    }
    
    public void fillForTest() {
        Resource__c res = new Resource__c();
        res.endpoint_name__c = 'test';
        res.uom__c = 'test';
        res.payload__c = 'test';
        res.Name = '/888/0/5850';
        insert res;
        
        res = new Resource__c();
        res.endpoint_name__c = 'test';
        res.uom__c = 'test';
        res.payload__c = 'test';
        res.Name = '/999/0/1234';
        insert res;
    }
    
    public void cleanFromTest() {
        List<Resource__c> data = [select Id FROM Resource__c WHERE Name = '/888/0/5850'];
        for (Integer i=0;data != null && data.size() > 0 && i<data.size();++i) {
            Resource__c doomed = data.get(i);
            delete doomed;
        }
        
        data = [select Id FROM Resource__c WHERE Name = '/999/0/1234'];
        for (Integer i=0;data != null && data.size() > 0 && i<data.size();++i) {
            Resource__c doomed = data.get(i);
            delete doomed;
        }
    }
    
    public void initValues() {
        List<Resource__c> data = [select Id, Name, endpoint_name__c, uom__c, payload__c from Resource__c WHERE Name = '/888/0/5850' LIMIT 1];
        if (data != null && data.size() > 0) {
            Resource__c res = data.get(0);
            this.endpoint = res.endpoint_name__c;
            this.uri = res.Name;
            this.payload = res.payload__c;
        }
    }
    
    public void initLocation() {
        List<Resource__c> data = [select Id, Name, endpoint_name__c, uom__c, payload__c from Resource__c WHERE Name = '/999/0/1234' LIMIT 1];
        if (data != null && data.size() > 0) {
            Resource__c res = data.get(0);
            try {
                this.latitude = '17.5010818';
                this.longitude = '78.3612395';
                //LocationWrapper location = (LocationWrapper)JSON.deserialize(res.payload__c,LocationWrapper.class);
                //this.latitude = location.latitude;
                //this.longitude = location.longitude;
                //this.altitude = location.msl;
                //this.speed = location.speed;
            }
            catch (Exception ex) {
                System.debug('initLocation: exception during json deserialization: ' + ex.getMessage());
                this.latitude = '0.0'; 
                this.longitude = '0.0';
                this.altitude = '0.0';
                this.speed = '0.0';
            }
        }
    }
}