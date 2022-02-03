public class ContactController {
    @AuraEnabled
    public static List<Contact> getContacts() {
        //adding comment
        List<Contact> contacts = [SELECT Id, Name, MailingStreet, Phone, Email, LeadSource FROM Contact LIMIT 5];
        return contacts;
    }
}