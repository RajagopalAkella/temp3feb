public class PromiseController2 {
	@AuraEnabled
    public static String getAccountName(String AccId){
        List<Account> a = [SELECT Id, Name from Account WHERE Id =: AccId];
        return String.valueOf(a[0].Name);
    }
}