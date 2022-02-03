public class SampleCall2 {
    
    @AuraEnabled
    public static JSON2Apex getAccountOrders (string ExternalAccId) {
        //ExternalAccId = '12345678901234A1';
        JSON2Apex resultOrders = genCompList(ExternalAccId); 
        return resultOrders;
    }    
    
    public static JSON2Apex genCompList(String ExtAccId) {
        //string DevURL = 'http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver2?ExtId=100';
        string DevURL = 'http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ExternalAccounts?LPID=' + ExtAccId;
        //                http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver3?LPID=12345678901234A1
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
        for (result res : ResOrders.ExternalAccounts) {
            ExtRes.add(res);
        }
        system.debug('#### ResOrders: '+ResOrders);
        return ResOrders;
    }
    
    public class JSON2Apex {
        @AuraEnabled
        public boolean StatusCode {get;set;}
        @AuraEnabled
        public string Severity {get;set;}
        @AuraEnabled
        public string StatusDescription {get;set;}
        @AuraEnabled
        public string ServerStatusCode {get;set;}
        @AuraEnabled
        public string ServerStatusDescription {get;set;}        
        @AuraEnabled
        public List<result> ExternalAccounts {get;set;}
    }
    
    public class result{
        @AuraEnabled
        public string LPID {get;set;}
        @AuraEnabled
        public string AccountGUID {get;set;}
        @AuraEnabled
        public string AccountNickname { get;set; }
        @AuraEnabled
        public string AccountNumber { get;set; }
        @AuraEnabled
        public string AccountType {get;set;}
        @AuraEnabled
        public string Container {get;set;}
        @AuraEnabled
        public string FiID {get;set;}
        @AuraEnabled
        public datetime LastUpdated {get;set;}
        @AuraEnabled
        public decimal RunningBalance {get;set;}
        @AuraEnabled
        public string YodleeMIDIdentifier {get;set;}
    }
        
}