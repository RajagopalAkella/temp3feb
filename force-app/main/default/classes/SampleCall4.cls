public class SampleCall4 {

    //This class is made to try calling SOAP of gmail account using REST - but not working - need to fix - only getting response and session id
     
    public static void genCompList() {        
        string DevURL = 'https://login.salesforce.com/services/Soap/u/35.0';
        string bodyStr = '<?xml version="1.0" encoding="UTF-8"?>';
        bodyStr = bodyStr + '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:partner.soap.sforce.com">';
        bodyStr = bodyStr + '<soapenv:Header>';
        bodyStr = bodyStr + '<urn:organizationId>00D90000000eRh1</urn:organizationId>';
        bodyStr = bodyStr + '</soapenv:Header>';
        bodyStr = bodyStr + '<soapenv:Body>';
        bodyStr = bodyStr + '<urn:login>';
        bodyStr = bodyStr + '<urn:username>akellaraj@gmail.com</urn:username>';
        bodyStr = bodyStr + '<urn:password>Sainath_7985</urn:password>';
        bodyStr = bodyStr + '</urn:login>';
        bodyStr = bodyStr + '</soapenv:Body>';
        bodyStr = bodyStr + '</soapenv:Envelope>';        
        string resultBodyGet;
        string resultStatusGet;
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setheader('SOAPAction','""');
        req1.setHeader('Content-Type', 'text/xml');
        req1.setBody(bodyStr);
        req1.setEndpoint(DevURL);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultBodyGet = res1.getBody();
        resultStatusGet = res1.getStatus();
        system.debug('response: ' + resultBodyGet);        
        string sesID = getValueFromXMLString(resultBodyGet, 'sessionId');
		System.debug('token is: ' + sesID);
        
        string newAccId = createAcc('NewAcc29Aug2018');
        system.debug('New account: ' + newAccId);
    }
    
    private static string createAcc(string accName) {
        string DevURL = 'https://ap1.salesforce.com/services/Soap/class/MyWebService';
        string bodyStr = '<?xml version="1.0" encoding="UTF-8"?>';
        bodyStr = bodyStr + '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:partner.soap.sforce.com">';
        bodyStr = bodyStr + '<soapenv:Header>';
        bodyStr = bodyStr + '<urn:organizationId>00D90000000eRh1</urn:organizationId>';
        bodyStr = bodyStr + '</soapenv:Header>';
        bodyStr = bodyStr + '<soapenv:Body>';
        bodyStr = bodyStr + '<urn:login>';
        bodyStr = bodyStr + '<urn:username>akellaraj@gmail.com</urn:username>';
        bodyStr = bodyStr + '<urn:password>Sainath_7985</urn:password>';
        bodyStr = bodyStr + '</urn:login>';
        bodyStr = bodyStr + '</soapenv:Body>';
        bodyStr = bodyStr + '</soapenv:Envelope>';        
        string resultBodyGet;
        string resultStatusGet;
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setheader('SOAPAction','""');
        req1.setHeader('Content-Type', 'text/xml');
        req1.setBody(bodyStr);
        req1.setEndpoint(DevURL);
        Http http = new Http();
        HTTPResponse res1 = http.send(req1);
        resultBodyGet = res1.getBody();
        resultStatusGet = res1.getStatus();
        return resultBodyGet;
    }
    
    private static string getValueFromXMLString(string xmlString, string keyField){
 		string valueFound = '';
 		if(xmlString.contains('<' + keyField + '>') && xmlString.contains('')){
 			try{
 				valueFound = xmlString.substring(xmlString.indexOf('<' + keyField + '>') + keyField.length() + 2, xmlString.indexOf('</' + keyField + '>')); 
 				}catch (exception e){
 					system.debug('Error in getValueFromXMLString. Details: ' + e.getMessage() + ' keyfield: ' + keyfield);
 					} 
 		}
 		return valueFound;
 	}
     
}