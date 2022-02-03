public class updateAllContactsCls {    
    @future
    public static void callcreateAcc (String accId)
    {
        System.debug('Account received:' + accId);
        List<Contact> allCnts = new List<Contact>();
        allCnts = [Select Id, Description, AccountId, Account.Description from Contact where AccountId= :accId];
        for(contact cnt : allCnts){
            cnt.Description = cnt.Account.Description;
        }
        update allCnts;		//this is necessary for both before and after trigger if operating in @future
    }
}