@RestResource(urlMapping='/myVals/*')
global without sharing class sampleRestEndPoint {

    /*
http://iot-df2015-raj-developer-edition.na130.force.com/mySite/services/apexrest/myVals/
http://iot-df2015-raj-developer-edition.na130.force.com/mySite/services/apexrest/myVals/sampleEmail1
*/  
    
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strEmail = '';
        strEmail = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        //strEmail = req.params.get('strEmail');
        List<customClass> ccList = new List<customClass>();
        List<profileData__c> result = new List<profileData__c>();
        if(strEmail == ''){
        	result = [SELECT Id, Name, userEmail__c, university__c, phone_no__c, city__c, degree_type__c, area_of_interest__c, degree__c, prev_education__c,
										specialization__c, skills__c,academic_acheivements__c,co_cir_achievements__c,internship_details__c,org_name__c,
										internship_desc__c,TimeVal__c,S3_internship_link__c,s3_cv_link__c FROM profileData__c];
        } else {
            result = [SELECT Id, Name, userEmail__c, university__c, phone_no__c, city__c, degree_type__c, area_of_interest__c, degree__c, prev_education__c,
										specialization__c, skills__c,academic_acheivements__c,co_cir_achievements__c,internship_details__c,org_name__c,
										internship_desc__c,TimeVal__c,S3_internship_link__c,s3_cv_link__c FROM profileData__c WHERE userEmail__c =: strEmail];
        }
        for(profileData__c pdl : result){
            ccList.add(new customClass(pdl));
        }
        //return JSON.serialize(ccList);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(ccList));
    }    

    @HttpPost
    global static String doPost(customClass sampObj) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        profileData__c pd = new profileData__c(
        	userEmail__c = sampObj.userEmail,
            university__c =sampObj.university,
            phone_no__c = sampObj.phone_no,
            city__c = sampObj.city,
            degree_type__c = sampObj.degree_type,
            area_of_interest__c = sampObj.area_of_interest,
            degree__c = sampObj.degree,
            prev_education__c = sampObj.prev_education,
            specialization__c= sampObj.specialization,
            skills__c = sampObj.skills,
            academic_acheivements__c = sampObj.academic_acheivements,
            co_cir_achievements__c = sampObj.co_cir_achievements,
            internship_details__c = sampObj.internship_details,
            org_name__c = sampObj.org_name,
            internship_desc__c = sampObj.internship_desc,
            TimeVal__c = sampObj.TimeVal,
            S3_internship_link__c = sampObj.S3_internship_link,
            s3_cv_link__c = sampObj.s3_cv_link
        );
        try{
            insert pd;
            return pd.Id;
        } catch(exception e){
            return 'Error inserting: ' + e.getMessage();
        }
        
    }
        
    @HttpDelete
    global static String doDelete() {
        String delres = '';
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userEmail = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        profileData__c pd = [SELECT Id FROM profileData__c WHERE userEmail__c = :userEmail];
        try{
            delete pd;
            delres = 'Deleted successfully';
        }catch(exception e){
            delres = 'Error deleting record: ' + e.getMessage();
        }
        return delres;
    }
    
    global class customClass{
        global String Id {get; set;}
        global String userEmail {get; set;}
        global String university {get; set;}
        global String phone_no {get; set;}
        global String city {get; set;}
        global String degree_type {get; set;}
        global String area_of_interest {get; set;}
        global String degree {get; set;}
        global String prev_education {get; set;}
        global String specialization {get; set;}
        global String skills {get; set;}
        global String academic_acheivements {get; set;}
        global String co_cir_achievements {get; set;}
        global String internship_details {get; set;}
        global String org_name {get; set;}
        global String internship_desc {get; set;}
        global String TimeVal {get; set;}
        global String S3_internship_link {get; set;}
        global String s3_cv_link {get; set;}
        global customClass(profileData__c pd){
            this.Id = pd.Id;
            this.userEmail = pd.userEmail__c;
            this.university = pd.university__c;
            this.phone_no = pd.phone_no__c;
            this.city = pd.city__c;
            this.degree_type = pd.degree_type__c;
            this.area_of_interest = pd.area_of_interest__c;
            this.degree = pd.degree__c;
            this.prev_education = pd.prev_education__c;
            this.specialization = pd.specialization__c;
            this.skills = pd.skills__c;
            this.academic_acheivements = pd.academic_acheivements__c;
            this.co_cir_achievements = pd.co_cir_achievements__c;
            this.internship_details = pd.internship_details__c;
            this.org_name = pd.org_name__c;
            this.internship_desc = pd.internship_desc__c;
            this.TimeVal = pd.TimeVal__c;
            this.S3_internship_link = pd.S3_internship_link__c;
            this.s3_cv_link = pd.s3_cv_link__c;
        }
    }
    
/*    


    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<sample__c> result = [SELECT Id, Name FROM sample__c];
        return JSON.serialize(result);
        //return JSON.serialize('Sample String');
    } 

    @HttpGet
    global static List<Account> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> result = [SELECT Id, Name FROM Account LIMIT 10];
        return result;
    } 

@HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name FROM Account WHERE Id = :accountId];
        return result;
    }    */
    
/*    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }  
  @HttpPost
    global static String doPost(String name,
        String phone, String website) {
        Account account = new Account();
        account.Name = name;
        account.phone = phone;
        account.website = website;
        insert account;
        return account.Id;
    } */
   
}