/**
 * Configuration Controller
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
public with sharing class ConfigurationController {            
    // in edit mode in page... so halt the poller
    private Boolean m_polling = true;
    
    // Toggle UI State properties
    private String m_toggle_state_ui = 'Turn OFF Page Refresh...';
    
    // Configuration instance
    private Configuration m_config = null;                     // our configuration settings...
    
    // DeviceServer
    private DeviceServer m_ds = null;                          // our device server instance
    
    // Our Endpoints
    public List<Endpoint__c> myEndpoints = null;               // my endpoints
    
    // Our Endpoints' Resources
    public List<Resource__c> myResources { set; }               // my endpoint(s) resources
    public Id resourceId {get; set;}
    private Map<Id,Resource__c> resourcesById { set; get; }
    
    // constructor
    public ConfigurationController() {
        this.m_config = new Configuration(this);               // our configuration class...
        this.m_ds = new DeviceServer(this.m_config);           // our device server instance
        this.myEndpoints = new List<Endpoint__c>();            // my endpoints
        this.myResources = new List<Resource__c>();            // my endpoint(s) resources   
    }
    
    // get our resources from the Salesforce DB...
    public List<Resource__c> getMyResources() {
        this.myEndpoints = [select Id, Name, Type__c from Endpoint__c];
        this.resourcesById = new Map<Id,Resource__c>([select Id, Name, endpoint_name__c, max_age__c, observable__c, payload__c from Resource__c]);
        return this.resourcesById.values();
    }
    
    // refresh the data values
    public PageReference refreshResourceValues() {
        this.getMyResources();
        return null;
    }
    
    // PUT the resource value to mDS
    public PageReference PutResourceValue() { 
        Resource__c res = resourcesById.get(resourceId);
        if (res != null) {
            this.m_ds.setPutEndpoint(res.endpoint_name__c);
            this.m_ds.setPutURI(res.Name);
            this.m_ds.setPutValue(res.payload__c);
            this.m_ds.putResourceValue(); 
        }
        return null; 
    }
    
    // GET the resource value from mDS
    public PageReference GetResourceValue() { 
        Resource__c res = resourcesById.get(resourceId);
        if (res != null) {
            res.payload__c = this.m_ds.getMDS(res.endpoint_name__c, res.Name);
            update res;
        }
        return null; 
    }
    
    public String getRestDebug() {
        List<Debug__c> debug_list = [SELECT Message__c, Counter__c from Debug__c];
        if (debug_list != null && debug_list.size() > 0) {
            Debug__c debug = debug_list.get(0);
            return debug.Message__c;
        }
        return 'OK-empty';
    }
    
    public void setRestDebug(String message) {
        //this.m_ds.restDebug(message);
    }
    
    // get polling status
    public Boolean getPolling() { System.debug('getPolling...'); return this.m_polling; }
    
    // set polling status
    public void setPolling(Boolean val) { this.m_polling = val; }
    
    // Enable Polling
    public void enablePolling() { this.setPolling(true); System.debug('enablePolling...'); }
    
    // Disable Polling
    public void disablePolling() { this.setPolling(false); System.debug('disablePolling...'); }
    
    // Toggle Polling
    public void togglePolling() { this.setPolling(!this.getPolling()); this.updateToggleUIState(); }
    
    // get the toggle UI state
    public String getToggleUIState() { return this.m_toggle_state_ui; }
    
    // update the Toggle UI State (for button UI...so reverse of setting...)
    public void updateToggleUIState() { 
        if (this.getPolling()) 
            this.m_toggle_state_ui = 'Turn OFF Page Refresh...'; 
        else
            this.m_toggle_state_ui ='Turn ON Page Refresh...';             
    }
    
    // set use tokens
    public void setUseTokens(Boolean use_tokens) { this.m_config.setUseTokens(use_tokens); }
    
    // get Domain
    public String getDomain() { return this.m_config.getDomain(); }
    
    // set Domain
    public void setDomain(String domain) { this.m_config.setDomain(domain); }
    
    // get Token
    public String getToken() { return this.m_config.getToken(); }
    
    // set Token
    public void setToken(String token) { this.m_config.setToken(token); }
    
    // get Server
    public String getServer() { return this.m_config.getServer(); }
    
    // set Server
    public void setServer(String server) { this.m_config.setServer(server); }
    
    // get UseTokens
    public Boolean getUseTokens() { return this.m_config.getUseTokens(); }
    
    // get Password
    public String getPassword() { return this.m_config.getPassword(); }
    
    // set Password
    public void setPassword(String password) { this.m_config.setPassword(password); }
    
    // get Username
    public String getUsername() { return this.m_config.getUsername(); }
    
    // set Username
    public void setUsername(String username) { this.m_config.setUsername(username); }
    
    // get Port
    public Integer getPort() { return this.m_config.getPort(); }
    
    // set Port
    public void setPort(Integer port) { this.m_config.setPort(port); }
    
    // get site URL
    public String getSiteURL() { return this.m_config.getSiteURL(); }
    
    // set site URL
    public void setSiteURL(String url) { this.m_config.setSiteURL(url); }
    
    // persist our configuration...
    public void SaveConfiguration() { this.m_config.saveConfiguration(); }
    
    // clear our configuration
    public void ClearConfiguration() { this.m_config.clearConfiguration(); }
    
    // clear out our mDS Endpoints
    public void ClearEndpoints() { this.m_ds.clearEndpointObjectInstances(); }
    
    // retrieve our mDS Endpoints
    public void RetrieveEndpoints() { this.m_ds.retrieveEndpoints(); }
    
    // subscribe to observable resources...
    public void SubscribeToObservableResources() { this.m_ds.subscribeToObservableResources(); }
    
    // setup the notification handler
    public void ResetNotificationURL() { this.m_ds.resetEventHandlerURL(); }
    
    // get the configuration
    public Configuration getConfig() { return this.m_config; }
    
    // get the device server
    public DeviceServer getDeviceServer() { return this.m_ds; }
    
    // configuration 
    public class Configuration {
        private ConfigurationController m_controller = null;
        // use mDS push-url (vs callback url)
        private Boolean m_use_push_url = true;                                       // true - push-url (v2.3),  false - callback (v2.4 - api.connector.mbed.org)

        // DEFAULT CONFIGURATION
        private String m_mds_server = '129.41.134.116';                              // Bluemix VM...v2.3
        private String m_domain = 'dfbridge1';                                       // default domain in mDS
        private Integer m_port = 8080;                                               // default REST port for mDS
        private String m_username = 'bridge';                                        // default username
        private String m_password = 'secret';                                        // default password
        private String m_api_token = 'CDT3E1RMHVPPRT777FXMNO55ZOVMNOQA3RTYVZ5Z';     // default API token
        private Boolean m_use_tokens = false;                                        // default is to use API Tokens
        private String  m_site_url = 'my-site-url.my-force-server.force.com';        // default site URL
        private Integer m_timeout_ms = 60000;                                        // HttpRequest timeout value (in ms) - 1 minute
        
        // constructor
        public Configuration() {
            this.m_controller = null;
            this.setSiteURL(null);
            this.load();
        }
        
        // constructor
        public Configuration(ConfigurationController controller) {
            this.m_controller = controller;
            this.setSiteURL(null);
            this.load();
        }
        
        // constructor
        public Configuration(Boolean noSiteURLInit) {
            this.m_controller = null;
            if (noSiteURLInit == false) this.setSiteURL(null);
            this.load();
        }
        
        // Default Getters/Setters (explicitly defined)
        public void setServer(String mds_server) { if (mds_server != null && mds_server.length() > 0) this.m_mds_server = mds_server; }
        public String getServer() { return this.m_mds_server; }
        public void setDomain(String domain) { if (domain != null && domain.length() > 0)  this.m_domain = domain; }
        public String getDomain() { return this.m_domain; }
        public void setPort(Integer port) { if (port > 0) this.m_port = port; }
        public Integer getPort() { return this.m_port; }
        public void setUsername(String username) { if (username != null && username.length() > 0) this.m_username = username; }
        public String getUsername() { return this.m_username; }
        public void setPassword(String password) { if (password != null && password.length() > 0)  this.m_password = password; }
        public String getPassword() { return this.m_password; }
        public void setToken(String api_token) { if (api_token != null && api_token.length() > 0)  this.m_api_token = api_token; }
        public String getToken() { return this.m_api_token; }
        public void enableTokens() { this.setUseTokens(true); }
        public void enableUserPass() { this.setUseTokens(false); }
        public void setUseTokens(Boolean use_tokens) { this.m_use_tokens = use_tokens; }
        public Boolean getUseTokens() { return this.m_use_tokens; }
        public Boolean usePushURL() { return this.m_use_push_url; }
        public ConfigurationController getController() { return this.m_controller; }
        public Integer getHttpRequestTimeout() { return this.m_timeout_ms; }
        
        // we can automate the setting of the Site URL...
        public String getSiteURL() { return this.m_site_url; }
        public void setSiteURL(String url) { 
            if (url != null && url.length() > 0) {
                // overrided URL
                this.m_site_url = url;
                System.debug('setSiteURL: Site URL(set): ' + this.m_site_url);
            }
            else {
                // find the default that is pinned to this Application
                List<Site> s_list = [SELECT Subdomain FROM Site WHERE Status = 'Active'];
                if (s_list != null && s_list.size() > 0) {
                    Site s = s_list.get(0);
                    try {
                        this.m_site_url = s.Subdomain + '.' + ApexPages.currentPage().getHeaders().get('Host').replace('visual.','').replace('c.','');
                        System.debug('setSiteURL: Site URL(init): ' + this.m_site_url);
                    }
                    catch (Exception ex) {
                        this.m_site_url = 'http://mds-sf-bridge-developer-edition.na34.force.com/';
                        System.debug('setSiteURL: SiteURL (error): ' + this.m_site_url + ' Exception: ' + ex.getMessage());
                    }
                }
                else {
                    // no site URL found...
                    System.debug('setSiteURL: No Site URL found! Please create one...');
                }
            } 
        }
        
        // reload the configuration
        private void load() {
            List<Configuration__c> config_list = [SELECT Name,Server__c,Domain__C,Port__c,SiteURL__c,UseTokens__c,Token__c,Username__c,Password__c from Configuration__c where Name = 'last' ];
            if (config_list != null && config_list.size() > 0) {
                Configuration__c config = config_list.get(0);
                setServer(config.Server__c);
                setDomain(config.Domain__c);
                setPort((Integer)config.Port__c);
                setUseTokens(config.UseTokens__c);
                setToken(config.Token__c);
                setUsername(config.Username__c);
                setPassword(config.Password__c);
                setSiteURL(config.SiteURL__c);
            }
        }
        
        // clear the configuration
        public void clearConfiguration() {
            // delete all object instances Configuration__c
            List<Configuration__c> config = [SELECT Id From Configuration__c];
            delete config;
            this.setSiteURL(null);
        }
        
        // save the configuration
        public void saveConfiguration() {
        	List<Configuration__c> config_list = [SELECT Name,Server__c,Domain__C,Port__c,SiteURL__c,UseTokens__c,Token__c,Username__c,Password__c from Configuration__c where Name = 'last' ];
            if (config_list != null && config_list.size() > 0) {
                Configuration__c config = config_list.get(0);
                config.Name = 'last';
		        config.Server__c = getServer();
		        config.Domain__c = getDomain();
		        config.Port__c = getPort();
		        config.UseTokens__c = getUseTokens();
		        config.Token__c = getToken();
		        config.Username__c = getUsername();
		        config.Password__c = getPassword();
		        config.SiteURL__c = getSiteURL();
		        update config;
            }
            else {
	            Configuration__c config = new Configuration__c();
	            config.Name = 'last';
	            config.Server__c = getServer();
	            config.Domain__c = getDomain();
	            config.Port__c = getPort();
	            config.UseTokens__c = getUseTokens();
	            config.Token__c = getToken();
	            config.Username__c = getUsername();
	            config.Password__c = getPassword();
	            config.SiteURL__c = getSiteURL();
	            insert config;
            }
            this.load();
        }
        
        // get our credentials
        public String getCredentials() { 
            if (this.m_use_tokens == true) {
                // API Token... 
                String authorizationHeader = ' Bearer ' + this.getToken();
                System.debug(authorizationHeader);
                return authorizationHeader;
            }
            else {
                // Basic Auth...
                String headerValue = EncodingUtil.base64Encode(Blob.valueOf(this.m_username + ':' + this.m_password));
                String authorizationHeader = ' Basic ' + headerValue;
                System.debug(authorizationHeader);
                return authorizationHeader;
            }
        }
    }
    
    // mDS device from REST call...
    public class MDSDevice {
        public string name {get; set;}
        public string type {get; set;}
        public string status {get; set;}
        public boolean q {get; set;}
        public List<MDSResource> resources {get; set;}
    }
    
    // mDS device's resources from RESt call...
    public class MDSResource {
        public string uri {get; set;}
        public string rt {get; set;}
        public boolean obs {get; set;}
        public string value {get; set;}
        public string type {get; set;}
    }
    
    // maintain list of active subscriptions 
    public class SubscriptionList {
        private List<Map<String,String>> m_subscriptions = null;
        
        // constructor
        public SubscriptionList() {
            this.m_subscriptions = new List<Map<String,String>>();
        }
        
        // add subscription
        public void addSubscription(String domain,String endpoint,String uri) {
            if (!this.containsSubscription(domain,endpoint,uri)) {
                System.debug('addSubscription: adding: ' + domain + ':' + endpoint + ':' + uri);
                this.m_subscriptions.add(this.makeSubscription(domain, endpoint, uri));
            }
        }
        
        // contains a given subscription?
        public boolean containsSubscription(String domain,String endpoint,String uri) {
            boolean has_subscription = false;
            
            Map<String,String> subscription = this.makeSubscription(domain, endpoint, uri);
            if (this.containsSubscription(subscription) >= 0) {
                System.debug('containsSubscription: does contain: ' + domain + ':' + endpoint + ':' + uri);
                has_subscription = true;
            }
            
            return has_subscription;
        }
        
        // remove a subscription
        public void removeSubscription(String domain,String endpoint,String uri) {
            Map<String,String> subscription = this.makeSubscription(domain, endpoint, uri);
            Integer index = this.containsSubscription(subscription);
            if (index >= 0) {
                System.debug('removeSubscription: removing: ' + domain + ':' + endpoint + ':' + uri);
                this.m_subscriptions.remove(index);
            }
        }
        
        // contains a given subscription?
        private Integer containsSubscription(Map<String,String> subscription) {
            Integer index = -1;
            
            for(Integer i=0;i<this.m_subscriptions.size() && index < 0;++i) {
                if (this.sameSubscription(subscription,this.m_subscriptions.get(i))) {
                    index = i;
                }
            }
            
            return index;
        }
        
        // compare subscriptions
        private boolean sameSubscription(Map<String,String> s1,Map<String,String> s2) {
            boolean same_subscription = false;
            
            // compare contents...
            if (s1.get('domain') != null && s2.get('domain') != null && s1.get('domain').equalsIgnoreCase(s2.get('domain'))) {
                if (s1.get('endpoint') != null && s2.get('endpoint') != null && s1.get('endpoint').equalsIgnoreCase(s2.get('endpoint'))) {
                    if (s1.get('uri') != null && s2.get('uri') != null && s1.get('uri').equalsIgnoreCase(s2.get('uri'))) {
                        // they are the same
                        same_subscription = true;
                    }
                }
            }
            
            return same_subscription;
        }
        
        // make subscription entry 
        private Map<String,String> makeSubscription(String domain,String endpoint,String uri) {
            Map<String,String> subscription = new Map<String,String>();
            subscription.put('domain', domain);
            subscription.put('endpoint',endpoint);
            subscription.put('uri',uri);
            return subscription;
        }
    }
    
    // Notification Wrapper
    public class NotificationWrapper {
        public String ep;
        public String path;
        public String ct;
        public String payload;
        public String timestamp;
        public String max_age;
    }
    
    // Resource Wrapper
    public class ResourceWrapper {
        public string path;
        public string rt;
        public string ct;
        public string obs;
    }
    
    // Registration Outer Wrapper class
    public class RegistrationWrapper {
        public String ep;
        public String ept;
        public List<ResourceWrapper> resources;
    }
    
    // NotificationMessage class
    public class NotificationMessage {
        List<NotificationWrapper> notifications;
    }
    
    // RegistrationMessage class
    public class RegistrationMessage {
        List<RegistrationWrapper> registrations;
    }

    // mDS Device Server 
    public class DeviceServer {
        private Configuration m_config = null;
        
        // base mDS URL
        private String m_base_url = null;
        
        // notification callback URL and JSON (callback URL)
        private String m_callback_url = null;
        
        // event handler URL
        private String m_event_handler_url = null;
        private String m_event_handler_json = null;
        
        // default event handler URL
        private String m_default_event_handler_url = null;
        private String m_default_event_handler_json = null;
        
        // PUT parameter - endpoint;
        private String m_put_endpoint = null;
        private String m_put_uri = null;
        private String m_put_value = null;
        
        // Subscription List 
        private SubscriptionList m_subscriptions = null;
        
        // HttpRequest timeout
        private Integer m_timeout_ms;
        
        // constructor
        public DeviceServer(Configuration config) {
            this.m_config = config;
            this.m_timeout_ms = config.getHttpRequestTimeout();
            this.m_subscriptions = new SubscriptionList();
        }
        
        // get subscriptions list
        public SubscriptionList getSubscriptions() { return this.m_subscriptions; }
        
        // PUT setter - endpoint
        public void setPutEndpoint(String endpoint) { this.m_put_endpoint = endpoint; }
        
        // PUT setter - URI
        public void setPutURI(String uri) { this.m_put_uri = uri; }
        
        // PUT setter - Value
        public void setPutValue(String value) { this.m_put_value = value; }
        
        // get the configuration
        public Configuration getConfig() { return this.m_config; }
        
        // build the mDS base URL
        private void buildBaseURL() {
            this.m_base_url = 'http://' + this.m_config.getServer() + ':' + this.m_config.getPort() + '/' + this.m_config.getDomain() + '/endpoints/';
            system.debug('buildBaseURL: ' + this.m_base_url);
        }
        
        // build the Callback URL
        public void buildCallbackURL(Boolean doPush) {
            if (doPush) {
                // use the push-url format
                this.m_callback_url = 'http://' + this.m_config.getServer() + ':' + this.m_config.getPort() + '/' + this.m_config.getDomain() + '/notification/push-url';
            }
            else {
                // use the callback url format
                this.m_callback_url = 'http://' + this.m_config.getServer() + ':' + this.m_config.getPort() + '/' + this.m_config.getDomain() + '/notification/callback';
            }
            System.debug('buildCallbackURL: ' + this.m_callback_url);
        }
        
        // create the callback headers
        private String createCallbackHeaders() {
            String mds_auth_json = this.createAuthenticatorJSON();
            String mds_domain_json = this.createAuthenticatorDomainJSON();
            return '\"headers\": {' + mds_auth_json + ',' + mds_domain_json + '}';
        }
        
        // create the notification authenticator JSON
        private String createAuthenticatorJSON() {
            return '\"MDSAuthenticator\":\"' + this.createAuthenticator() + '\"';
        }
        
        // create the notification authenticator
        public String createAuthenticator() {
            // we build out a different authenticator depending on whether we use basic auth or the API token
            if (this.getConfig().getUseTokens()) {
                // API Tokens used... just use the API Token
                return this.getConfig().getToken();
            }
            else {
                // Basic Auth used...
                String auth = this.getConfig().getUsername() + ':' + this.getConfig().getPassword();
                
                // Base64 encode it...
                return EncodingUtil.base64Encode(Blob.valueOf(auth));
            }
        }
        
        // create the notification authenticator domain JSON
        public String createAuthenticatorDomainJSON() {
            return '\"Domain\":\"' + this.getConfig().getDomain() + '\"';
        }
        
        // build mDS EventHandler URL variables...
        public void buildEventHandlerURL() {
            // Actual mDS event handler.. "/services/apexrest/events" is the URI...
            this.m_event_handler_url = 'https://' + this.getConfig().getSiteURL() + '/services/apexrest/events';
            System.debug('buildEventHandlerURL: ' + this.m_event_handler_url);
            
            // set the mDS event handler
            this.m_default_event_handler_url = 'http://127.0.0.1:8083/dsevents';
            
            // create the json for callback based webhooks...
            String headers = this.createCallbackHeaders();
            if (headers != null && headers.length() > 0) { 
                this.m_event_handler_json = '{ \"url\":\"' + this.m_event_handler_url + '\", ' + headers + '}';
                this.m_default_event_handler_json = '{ \"url\":\"' + this.m_default_event_handler_url + '\",' +  headers + '}';
            }
            else {
                this.m_event_handler_json = '{ \"url\":\"' + this.m_event_handler_url + '\"}';
                this.m_default_event_handler_json = '{ \"url\":\"' + this.m_default_event_handler_url + '\"}';
            }    
            
            System.debug('buildEventHandlerURL (JSON): ' + this.m_event_handler_json);
        }
        
        // create the subscription URL
        public String createSubscriptionURL(String domain,String endpoint,String resource_uri) {
            String url= 'http://' + this.getConfig().getServer() + ':' + this.getConfig().getPort() + '/' + 
                                    this.getConfig().getDomain() + '/subscriptions/' + endpoint + resource_uri;
           System.debug('createSubscriptionURL: ' + url);
           return url;
        }
        
        // Retrieve Endpoints
        public void retrieveEndpoints() {
            // build the base URL
            this.buildBaseURL();
            
            // pull the list of endpoints from mDS
            this.pullEndpointsFromMDS();
        }
        
        // insert retrieved endpoints into object instances
        public void mdsEndpointsToObjectInstances(List<MDSDevice> devices) {
           if (devices != null && devices.size() > 0) {
               for(MDSDevice device : devices) {
                   Endpoint__c ep = new Endpoint__c();
                   ep.Name = device.name;
                   ep.Type__c = device.type;
                   insert ep;
                   for(MDSResource resource : device.resources) {
                       Resource__c res = new Resource__c();
                       res.endpoint_name__c = ep.Name;
                       res.Name = resource.uri;
                       res.observable__c = resource.obs;
                       res.payload__c = resource.value;
                       res.max_age__c = 120;
                       insert res; 
                   }
                   System.debug('DEVICE: ' + device);
               }
           }
           else if (devices != null) {
               System.debug('DEVICES: none!!!');
           }
           else {
               System.debug('DEVICES: NULL!!!');
           }
        }
        
        // clear out our current endpoint object instances
        public void clearEndpointObjectInstances() {
            // delete all object instances in Endpoint__c and Resource__c
            List<Endpoint__c> existing_endpoints = [SELECT Id From Endpoint__c];
            delete existing_endpoints;
            
            // delete all resources for our Endpoints
            List<Resource__c> existing_resources = [SELECT Id From Resource__c];
            delete existing_resources;
        }
        
        // pull all endpoints from our mDS server
        public void pullEndpointsFromMDS() { 
            // extract the mDS devices and its resources...
            List<MDSDevice> devices = this.getDevicesAndResources();
            
            // next clear our instances - this is AFTER the web calls... 
            this.clearEndpointObjectInstances();
            
            // convert into the table
            this.mdsEndpointsToObjectInstances(devices);
        }
        
        // get the mDS devices and each devices resources
        public List<MDSDevice> getDevicesAndResources() {
            List<MDSDevice> devices = this.pullMDSEndpoints();
            for(MDSDevice device : devices) {
                device.resources = this.pullMDSDevice(device.name);
                for(MDSResource resource : device.resources) {
                    resource.value = this.getMDS(device.name, resource.uri);
                }
            }
            return devices;
        }
        
        private List<MDSDevice> pullMDSEndpoints() {
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);
            req.setEndpoint(this.m_base_url);
            req.setHeader('Authorization',this.getConfig().getCredentials());
            req.setHeader('Content-Type','text/plain');
            req.setMethod('GET');
              
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            System.debug('pullMDSEndpoints: ' + res.getStatusCode());
            
            try {    
                List<MDSDevice> devices = (List<MDSDevice>)JSON.deserialize(res.getBody(),List<MDSDevice>.class);  
                return devices;
            }
            catch(Exception ex) {
                System.debug('pullMDSEndpoints: Exception caught: ' + ex.getMessage());
                List<MDSDevice> devices = new List<MDSDevice>();
                return devices;
            }
        }
        
        public List<MDSResource> pullMDSDevice(string device_name) {
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);
            req.setEndpoint(this.m_base_url+device_name);
            req.setHeader('Authorization', this.getConfig().getCredentials());
            req.setHeader('Content-Type','text/plain');
            req.setMethod('GET');
              
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            System.debug('pullMDSDevice: ' + res.getStatusCode());
            try {
                List<MDSResource> resources = (List<MDSResource>)JSON.deserialize(res.getBody(),List<MDSResource>.class);  
                return resources;
            }
            catch (Exception ex) {
                System.debug('pullMDSDevice: device_name: ' + device_name + ' exception: ' + ex.getMessage());
                return new List<MDSResource>();
            }
        }
        
        public String getMDS(String device, String resource) {
            this.buildBaseURL();
            System.debug('GET: ' + this.m_base_url+device+resource+'?sync=true');
            
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);    
            req.setEndpoint(this.m_base_url+device+resource+'?sync=true');
            req.setHeader('Authorization', this.getConfig().getCredentials());
            req.setHeader('Domain',this.getConfig().getDomain());
            req.setHeader('Content-Type','text/plain');
            req.setMethod('GET');
                
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            String result = res.getBody();
            System.debug('getMDS: ' + res.getStatusCode() + ' body: ' + result);
            return result;  
        }
        
        public boolean putMDS(String device, String resource, String body) {
            this.buildBaseURL();
            System.debug('PUT: ' + this.m_base_url+device+resource+'?sync=true  BODY:[' + body +']');
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);
            req.setEndpoint(this.m_base_url+device+resource+'?sync=true');
            req.setHeader('Authorization', this.getConfig().getCredentials());
            req.setHeader('Domain',this.getConfig().getDomain());
            req.setHeader('Content-Type','text/plain');
            req.setMethod('PUT');
            if (body != null) req.setBody(body);
        
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            String result = res.getBody();
            System.debug('putMDS: ' + res.getStatusCode() + ' body: ' + result);
            return res.getStatusCode() == 200;
        }
        
        // subscribe to observable resources
        public void subscribeToObservableResources() {
            // reset the callback URL
            System.debug('build callback url');
            this.buildCallbackURL(this.getConfig().usePushURL());
            
            // reset the event handler URL
            System.debug('building event handler url');
            this.buildEventHandlerURL();
            
            // establish the event handler URL
            System.debug('establishing the event handler URL');
            this.establishEventHandlerURL();
            
            // delete any old subscriptions
            System.debug('clear out any old subscriptions');
            this.deleteSubscriptions();
            
            // setup subscriptions
            System.debug('setting up subscriptions');
            this.setupSubscriptions();
        }
        
        // reset the event handler URL
        private boolean resetEventHandlerURL() {
            // reset the callback URL
            System.debug('build callback url');
            this.buildCallbackURL(this.getConfig().usePushURL());
            
            // reset the event handler URL
            System.debug('building event handler url');
            this.buildEventHandlerURL();
            
            // delete any old subscriptions
            System.debug('clear out any old subscriptions');
            this.deleteSubscriptions();
            
            // delete the notification URL
            return this.setEventHandlerURL('DELETE',this.getConfig().usePushURL(),this.m_default_event_handler_url,this.m_default_event_handler_json);
        }
        
        // establish the event handler URL
        private boolean establishEventHandlerURL() {
            return this.setEventHandlerURL('PUT',this.getConfig().usePushURL(),this.m_event_handler_url,this.m_event_handler_json);
        }
        
        // establish the event handler URL
        private boolean setEventHandlerURL(String verb,boolean pushURL, String eventHandlerURL, String eventHandlerJSON) {
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);
            req.setEndpoint(this.m_callback_url);
            System.debug('setEventHandlerURL: URL: ' + this.m_callback_url);
            req.setHeader('Authorization',this.getConfig().getCredentials());
            req.setHeader('Domain',this.getConfig().getDomain());
            req.setHeader('Host','' + this.getConfig().getServer() + ':' + this.getConfig().getPort());
            req.setMethod(verb);
            if(pushURL) {
                // push URL
                System.debug('setEventHandlerURL: using push-url');
                if (verb.equalsIgnoreCase('delete') == false) req.setBody(eventHandlerURL);
                req.setHeader('Content-Type','text/plain');
            }
            else {
                // callback URL
                System.debug('setEventHandlerURL: using callback');
                if (verb.equalsIgnoreCase('delete') == false) req.setBody(eventHandlerJSON);
                req.setHeader('Content-Type','application/json');
            }
                
            HTTP http = new HTTP();
            System.debug('setEventHandlerURL: sending request... ');
            HTTPResponse res = http.send(req);
            System.debug('setEventHandlerURL: ' + res.getStatusCode());
            return res.getStatusCode() == 200;
        }
        
        // delete subscriptions
        private void deleteSubscriptions() {
            List<Resource__c> resources = this.getConfig().getController().getMyResources();
            for(Resource__c resource : resources) {
                if (resource.observable__c == true) {
                    // remove any previous subscriptions
                    this.deleteSubscription(this.getConfig().getDomain(),resource.endpoint_name__c,resource.Name);
                }
            }
        }
        
        // setup the subscriptions to observable resources
        private void setupSubscriptions() {
            List<Resource__c> resources = this.getConfig().getController().getMyResources();
            for(Resource__c resource : resources) {
                if (resource.observable__c == true) {
                    // create new subscription
                    this.createNewSubscription(this.getConfig().getDomain(),resource.endpoint_name__c,resource.Name);
                }
            }
        }
        
        // delete a subscription
        private void deleteSubscription(String domain,String endpoint,String resource_uri) {
            // build out the subscription URL
            String url = this.createSubscriptionURL(domain,endpoint,resource_uri);
            System.debug('deleteSubscription: URL: ' + url);
            
            // send the DELETE
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);
            req.setEndpoint(url);
            req.setHeader('Authorization', this.getConfig().getCredentials());
            req.setHeader('Content-Type','text/plain');
            req.setMethod('DELETE');
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            System.debug('deleteSubscription: ' + res.getStatusCode());
            
            // remove from the subscription list
            this.m_subscriptions.removeSubscription(domain,endpoint,resource_uri);
        }
        
        // create a new subscription
        private void createNewSubscription(String domain,String endpoint,String resource_uri) {
            // build out the subscription URL
            String url = this.createSubscriptionURL(domain,endpoint,resource_uri) + '?sync=true';
            System.debug('createNewSubscription: URL: ' + url);
            
            HttpRequest req = new HttpRequest();
            req.setTimeout(this.m_timeout_ms);
            req.setEndpoint(url);
            req.setHeader('Authorization', this.getConfig().getCredentials());
            req.setHeader('Content-Type','text/plain');
            req.setMethod('PUT');
            req.setBody('');                                                            // must be present...
            HTTP http = new HTTP();
            HTTPResponse res = http.send(req);
            System.debug('createNewSubscription: ' + res.getStatusCode());
            
            // add to the subscriptions list
            this.m_subscriptions.addSubscription(domain,endpoint,resource_uri);
        }
        
        private String getBase64Value(String payload) {
            return EncodingUtil.base64Decode(payload).toString();
        }
        
        // put the resource value
        public void putResourceValue() {
            System.debug('putResourceValue: ' + this.m_put_endpoint + ':' + this.m_put_uri + ':' + this.m_put_value);
            
            // put the value to the resource
            if (this.putMDS(this.m_put_endpoint,this.m_put_uri,this.m_put_value)) {
                // succeeded.. update...
                System.debug('putResourceValue: SUCCESS');
                
                try {
                    // refresh values
                    this.retrieveEndpoints();
                }
                catch (Exception ex) {
                    System.debug('putResourceValue: exception caught during refreshResourceValues: ' + ex.getMessage());
                }
            }
            else {
                // failed... revert...
                System.debug('putResourceValue: FAILED');
            }
        }
        
        // validate the input notification
        public Boolean notificationValidated(RestRequest request) {
            Boolean validated = false;
            
            // get the authentication header we have provided mDS to supply on our behalf
            String mds_domain = null;
            String mds_auth = null; 
            
            // check for the older push-url being used if so, we authenticate by default
            if (this.getConfig().usePushURL() == true) {
                return true;
            }
            
            try {
                mds_domain = request.headers.get('Domain');
                mds_auth = request.headers.get('MDSAuthenticator');
            }
            catch (Exception ex) {
                System.debug('notificationValidated: Exception: ' + ex.getMessage());
                validated = true;
            }
            
            // compare with what we have configured
            if (mds_domain != null && mds_domain.length() > 0 && mds_domain.equalsIgnoreCase(this.getConfig().getDomain())) {
                // mDS domain checks OK... now check the authenticator
                if (mds_auth != null && mds_auth.length() > 0 && mds_auth.equalsIgnoreCase(this.createAuthenticator())) {
                    // notification is authentic
                    validated = true;
                    System.debug('Notification validated: domain: ' + mds_domain + ' auth: ' + mds_auth);
                }
                else {
                    // did not pass MDS authentication
                    if (mds_auth == null || mds_auth.length() <= 0) mds_auth = 'EMPTY';
                    System.debug('Authenticator not found in notification... ignoring...(' + mds_auth + ')');
                }
            }
            else {
                // did not pass MDS Domain
                if (mds_domain == null || mds_domain.length() <= 0) mds_domain = 'EMPTY';
                System.debug('mDS Domain not found in notification... ignoring...(' + mds_domain + ')');
            }
            
            // return the validation status
            return validated;
        }
        
        // process resource notification
        public String processResourceNotification(String jsonstring) {
            try { 
                NotificationMessage message = (NotificationMessage)JSON.deserialize(jsonstring,NotificationMessage.class);
                List<NotificationWrapper> notifications = message.notifications;
                
                System.debug('Number of notifications: ' + message.notifications.size());
                
                for(Integer i=0;notifications != null && i<notifications.size();++i) {
                    NotificationWrapper notification = notifications.get(i);
                    
                    // get the endpoint name
                    String ep_name = notification.ep;
                    
                    // get the endpoint resource URI
                    String uri = notification.path;
                    
                    // get the (new) payload
                    String payload = this.getBase64Value(notification.payload); 
                    
                    system.debug('Notification: ep: ' + ep_name + ' path: ' + uri + ' payload: ' + payload);
                                        
                    // get the resources from SF...
                    List<Resource__c> resources = [select Id, Name, endpoint_name__c, max_age__c, observable__c, payload__c from Resource__c];
                    
                    // Loop and find the resource that matches the one in the JSON...
                    boolean done = false;
                    for(Integer j=0;!done && j<resources.size();++j) {
                        // get the ith resource
                        Resource__c res = resources.get(j);
                        
                        // same resource?
                        if (ep_name.equalsIgnoreCase(res.endpoint_name__c) && uri.equalsIgnoreCase(res.Name)) {
                            res.payload__c = payload;
                            update res;
                            done = true;
                        }
                    }
                }
                return 'NOTIFY-OK';
                
            }
            catch (Exception ex) {
                System.debug('processResourceNotification: Exception: ' + ex.getMessage());
                return 'FAIL';
            }       
        }
        
        // process registration notification
        public String processRegistrationNotification(String jsonstring) {
            try {         
                RegistrationMessage message = (RegistrationMessage)JSON.deserialize(jsonstring,RegistrationMessage.class);
                List<RegistrationWrapper> registrations = message.registrations;
                
                System.debug('Number of registrations: ' + message.registrations.size());
                
                for(Integer i=0;registrations != null && i<registrations.size();++i) {
                    RegistrationWrapper registration = registrations.get(i);
                    // get the endpoint name
                    String ep = registration.ep;
                    
                    System.debug('Endpoint: ' + ep);
                    
                    // get the resources list
                    List<ResourceWrapper> resources = registration.resources; 
                    for(Integer j=0;resources != null && j<resources.size();++j) {
                        ResourceWrapper resource = resources.get(j);
                        String uri = resource.path;
                        
                        System.debug('URI: ' + uri);

                        // now with both ep and uri... we can re-register this endpoint resource
                        if (this.m_subscriptions.containsSubscription(this.m_config.getDomain(),ep,uri)) {
                            // delete any old subscription
                            this.deleteSubscription(this.getConfig().getDomain(),ep,uri);
                            
                            // re-create the subscription
                            this.createNewSubscription(this.getConfig().getDomain(),ep,uri);
                        }
                    }
                }
                
                return 'REG-OK';
            }
            catch (Exception ex) {
                System.debug('processRegistrationNotification: Exception: ' + ex.getMessage());
                return 'FAIL';
            }
        }
        
        // is our json a resource notification?
        public boolean isResourceNotification(String jsonstring) {
            boolean is_resource_notification = false;
                        
            try {
                NotificationMessage message = (NotificationMessage)JSON.deserialize(jsonstring,NotificationMessage.class);
                if (message.notifications != null && message.notifications.size() > 0) { 
                    is_resource_notification = true;
                    System.debug('isResourceNotification: notification json: ' + jsonstring);
                }
            }
            catch (Exception ex) {
                System.debug('isResourceNotification: Exception: ' + ex.getMessage());
            }
            
            return is_resource_notification;
        }
        
        // is our json a registration notification?
        public boolean isRegistrationNotification(String jsonstring) {
            boolean is_registration_notification = false;
            
            try {
                RegistrationMessage message = (RegistrationMessage)JSON.deserialize(jsonstring,RegistrationMessage.class);
                if (message.registrations != null && message.registrations.size() > 0) {
                    is_registration_notification = true;
                    System.debug('isRegistrationNotification: registration json: ' + jsonstring);
                }
            }
            catch (Exception ex) {
                System.debug('isRegistrationNotification: Exception: ' + ex.getMessage());
            }
            
            return is_registration_notification;
        }
        
        // process the notification
        public String processNotification(String jsonstring) {
            String response = 'UNSUPPORTED';
            
            if (jsonstring != null && jsonstring.length() > 0) { 
                try {
                    // check for resource updates...   
                    if (this.isResourceNotification(jsonstring)) {
                        response = this.processResourceNotification(jsonstring);
                        
                        // DEBUG
                        this.restDebug('notification: ' + jsonstring + ':' + response);
                    }
                    
                    // check for registrations...
                    if (this.isRegistrationNotification(jsonstring)) { 
                        if (response == null) {
                            response = this.processRegistrationNotification(jsonstring);
                            
                            // DEBUG
                            this.restDebug('registration: ' + jsonstring + ':' + response);
                        }
                        else {
                            response = response + ':' + this.processRegistrationNotification(jsonstring);
                            
                            // DEBUG
                            this.restDebug('registration(append): ' + jsonstring + ':' + response);
                        }
                    }        
                }
                catch(Exception ex) {
                    System.debug('processNotification: Exception caught: ' + ex.getMessage());
                    response = 'ERROR: ' + ex.getMessage();
                }
            }
            
            return response;
        }
        
        public void restDebug(String message) {
            List<Debug__c> debug_list = [Select Id, Name, Message__c, Counter__c from Debug__c];
            if (debug_list != null && debug_list.size() > 0) {
                Debug__c debug = debug_list.get(0);
                debug.Message__c = this.debugMe(message,debug.Counter__c);
                debug.Counter__c = debug.Counter__c + 1;
                update debug;
            }
            else {
                Debug__c debug = new Debug__c();
                Decimal counter = 0;
                debug.Name = 'debug';
                debug.Message__c = this.debugMe(message,counter);
                debug.Counter__c = counter + 1;
                insert debug;
            }
        }
        
        private String debugMe(String jsonstring,Decimal counter) {
            return '(' + counter +  '): ' + jsonstring;
        }
    }
}