public class SampleCall {
    
    @AuraEnabled
    public static JSON2Apex getAccountOrders (string ExternalAccId) {
        //ExternalAccId = '100';
        JSON2Apex resultOrders = genCompList(ExternalAccId); 
        return resultOrders;
    }    
    
    public static JSON2Apex genCompList(String ExtAccId) {
        //string DevURL = 'http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver2?ExtId=100';
        string DevURL = 'http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver2?ExtId=' + ExtAccId;
        string resultBodyGet;
        string resultStatusGet;
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setHeader('Accept', 'application/json');
        req1.setEndpoint(DevURL);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultBodyGet = res1.getBody();
        resultStatusGet = res1.getStatus();
        JSON2Apex ResOrders = (JSON2Apex) JSON.deserialize(resultBodyGet, JSON2Apex.class); 
        list<result> ExtRes = new list<result>();
        for (result res : ResOrders.MyOrderList) {
            ExtRes.add(res);
        }
        system.debug('#### ResOrders: '+ResOrders);
        return ResOrders;
    }
    
    public class JSON2Apex {
        @AuraEnabled
        public boolean status {get;set;}
        @AuraEnabled
        public string message {get;set;}
        @AuraEnabled
        public List<result> MyorderList {get;set;}
    }
    
    public class result{
        @AuraEnabled
        public string MyID {get;set;}
        @AuraEnabled
        public string MyName {get;set;}
        @AuraEnabled
        public string MyOrderID { get;set; }
        @AuraEnabled
        public string MyExtID { get;set; }
    }
        
}