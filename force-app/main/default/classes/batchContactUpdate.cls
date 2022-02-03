global class batchContactUpdate implements Database.Batchable<sObject> {
    Map<Id, Account> trigAccsMap = new Map<Id, Account>();
    global batchContactUpdate(Map<Id, Account> trigAccs){
        trigAccsMap = trigAccs;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query = 'SELECT Id, Description, AccountId, Account.Description FROM Contact where AccountId IN :trigAccsMap.keyset()';
        //return Database.getQueryLocator(query);
        return DataBase.getQueryLocator([SELECT Id, Description, AccountId, Account.Description FROM Contact where AccountId IN :trigAccsMap.keyset()]);
    }
     
    global void execute(Database.BatchableContext BC, List<Contact> conList) {        
        for(Contact con : conList) {       	// process each batch of records default size is 200 
            con.Description = con.Account.Description;
        }
        try {
            update conList;
        } catch(Exception e) {
            System.debug(e);
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}