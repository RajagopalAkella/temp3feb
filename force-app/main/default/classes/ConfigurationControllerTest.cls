@isTest 
private class ConfigurationControllerTest {
	
    static testMethod void validateConfiguration() {
		String resource_update_json = '{"notifications":[{"ep":"mbed-ble-hrm-dongle","path":"/888/0/5850","payload":"NjcuMA\u003d\u003d","max-age":60}]}';
		String registration_json = '{"registrations":[{"ep":"mbed-motor-sens","ept":"mbed-device","resources":[{"path":"/777/0/7777","rt":"StarterKit","ct":"","obs":true},{"path":"/dev/mdl","ct":"","obs":false},{"path":"/dev/mfg","ct":"","obs":false}]}]}';
    	
    	StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('myStaticResource');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, mock);

    	// Configuration Controller
    	ConfigurationController controller = new ConfigurationController();
    	
    	// get the device server
        ConfigurationController.DeviceServer ds = controller.getDeviceServer();
    	
    	// GET
        ds.getMDS('mbed-ble-hrm-dongle','/"888/0/5850');
        
        // PUT
        ds.putMDS('mbed-ble-hrm-dongle','/"888/0/5850','0');
        ds.putMDS('mbed-ble-hrm-dongle','/"888/0/5850','1');
        ds.putMDS('mbed-ble-hrm-dongle','/"888/0/5850','0'); 
        
        ds.getDevicesAndResources();
        ds.pullMDSDevice('doug');
        ds.putResourceValue(); 
    	
    	controller.ClearConfiguration();
    	controller.getPolling();
    	controller.enablePolling();
    	controller.disablePolling();
    	controller.togglePolling();
    	controller.getToggleUIState();
    	controller.setUseTokens(true);
    	controller.setUseTokens(false);
    	controller.getDomain();
    	controller.setDomain('dfbridge5'); 
    	controller.getServer();
    	controller.setServer('129.41.134.39');
        controller.getPort();
        controller.setPort(8080);
        controller.getUseTokens();
        controller.getPassword();
        controller.setPassword('secret');
        controller.getUsername();
        controller.setUsername('bridge');
        controller.getToken();
        controller.setToken('CDT3E1RMHVPPRT777FXMNO55ZOVMNOQA3RTYVZ5Z');
        controller.setSiteURL(null);
        controller.setSiteURL('http://mds-sf-bridge-developer-edition.na34.force.com/');
        controller.getSiteURL();
        controller.RetrieveEndpoints();
        controller.SubscribeToObservableResources();
        controller.ResetNotificationURL();
        controller.getMyResources();
    	controller.refreshResourceValues();
    	controller.PutResourceValue();
    	controller.GetResourceValue();
    	controller.SaveConfiguration();
        controller.ClearEndpoints();
        controller.updateToggleUIState();
        
        // process a notification
        ds.isResourceNotification(resource_update_json);
		ds.isRegistrationNotification(registration_json);
		ds.isResourceNotification(registration_json );
		ds.isRegistrationNotification(resource_update_json);
        ds.processNotification(resource_update_json);
        ds.processNotification(registration_json);
        
        // test callback notification processors
        ds.processResourceNotification(resource_update_json);
		ds.processRegistrationNotification(registration_json);
                
         // get our configuration and reload it...
        ConfigurationController.Configuration config = controller.getConfig();
        
        config.setDomain('hello');
        config.setServer('hello');
        config.setPort(1234);
        config.setToken('abcdef');
        config.setUsername('foo');
        config.setPassword('bar');
        config.enableTokens();
        config.enableUserPass();
        //config.getCredentials();
        
        ConfigurationController.SubscriptionList sublist = ds.getSubscriptions();
        sublist.addSubscription('domain','endpoint','uri');
        sublist.containsSubscription('foo','bar','here');
        sublist.containsSubscription('domain','endpoint','uri');
        sublist.removeSubscription('domain','endpoint','uri');
        
        ds.setPutEndpoint('doug');
        ds.setPutURI('doug');
        ds.setPutValue('doug');
        ds.buildCallbackURL(false);
        ds.buildCallbackURL(true);
        ds.createAuthenticator();
        ds.createAuthenticatorDomainJSON();
        ds.buildEventHandlerURL();
        ds.createSubscriptionURL('foo','bar','doug');
        ds.clearEndpointObjectInstances();
        ds.mdsEndpointsToObjectInstances(null);
        
        ConfigurationController.Configuration config2 = new ConfigurationController.Configuration();
        ConfigurationController.Configuration config3 = new ConfigurationController.Configuration(false);
        ConfigurationController.Configuration config4 = new ConfigurationController.Configuration(true);
        ConfigurationController.DeviceServer ds2 = new ConfigurationController.DeviceServer(config);
        
        config.getCredentials();
        
        ConfigurationController.MDSResource resource = new ConfigurationController.MDSResource();
        resource.uri = 'doug';
        resource.rt = 'doug';
        resource.obs = false;
        resource.value = 'doug';
        resource.type = 'doug';
        
        ConfigurationController.MDSDevice device = new ConfigurationController.MDSDevice();
        device.name = 'doug';
        device.type = 'doug';
        device.status = 'OK';
        device.q = false;  
        device.resources = null;
        
        EventHandler.doPut();
        
        MapViewController mvc = new MapViewController();
        mvc.fillForTest();
        mvc.RefreshResourceValues();
        mvc.initValues();
        mvc.initLocation();
        mvc.endpoint = 'doug';
        mvc.uri = 'doug';
        mvc.latitude = 'doug';
        mvc.longitude = 'doug';
        mvc.payload = 'doug';
        mvc.altitude = 'doug';
        mvc.speed = 'doug';
        mvc.cleanFromTest();
    }
}