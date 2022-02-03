public class PromiseController {
    @AuraEnabled
    public static String getAccountName(String AccId){
        List<Account> a = [SELECT Id, Name from Account WHERE Id =: AccId];
        return String.valueOf(a[0].Name);
    }
	@AuraEnabled
    public static String executeMethod1(String message ){
        //integer i = 1/0;
        return ' From Server executeMethod1 -->' +message ;
    }
    @AuraEnabled
    public static String executeMethod2(String message ){       
        return ' From Server executeMethod2 -->' +message ;
    }
    @AuraEnabled
    public static String executeMethod3(String message ){
        return ' From Server  executeMethod3-->' +message ;
    } @AuraEnabled
    public static String executeMethod4(String message ){
        return ' From Server executeMethod4 -->' +message ;
    } @AuraEnabled
    public static String executeMethod5(String message ){
        return ' From Server executeMethod5-->' +message ;
    }
}