public class REST_Example1 {
public string apikey; 
    public string cid;
    public string csec;
    
    public class CompListJSON {
        list<string> CompanyIDs;
        public CompListJSON(list<string> sCompanyID){
            this.CompanyIDs = sCompanyID;
        }
    }
    
    public void genCompList() {
        String methodurl = 'http://akellarajgmail-developer-edition.ap1.force.com/myapi/services/apexrest/ver2?ExtId=100';
        string resultBodyGet;
        string resultStatusGet;
        string accTok;
        accTok = 'oHiDy0lm-5DU8-gnaP-gMEA-ORXgP';
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setHeader('accessToken', accTok);
        req1.setHeader('Accept', 'application/json');
        req1.setEndpoint(methodurl);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultBodyGet = res1.getBody();
        resultStatusGet = res1.getStatus();
        System.debug('########## resultBodyGet: ' + resultBodyGet);
        System.debug('########## resultStatusGet: ' + resultStatusGet);
           
        /*
        CompListJSON companyIds;
        companyIds=(CompListJSON)JSON.deserialize(resultBodyGet, CompListJSON.class);
        
        System.debug('########## convertedList: ' + companyIds.CompanyIDs);

        //list<string> compIDs;
        for(string comp : companyIds.CompanyIDs){
            system.debug('########## IteratedList: ' + comp);
            //compIDs.add(comp.CompanyIDs);
        }
        */
    }
}