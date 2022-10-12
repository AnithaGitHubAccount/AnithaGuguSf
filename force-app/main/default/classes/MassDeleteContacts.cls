public with sharing class MassDeleteContacts {
    public MassDeleteContacts() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        return [
          SELECT Id, firstName, lastName, Title, Phone, Email 
          FROM Contact WHERE firstName!=null order by createdDate desc]; 
        } 
    @AuraEnabled
    public static void deleteSelectedContacts(List<Id> selContactIdList){
      List<Contact> contactList = new  List<Contact>();
      contactList = [select id from contact where id in:selContactIdList];
      if(contactList!=null && contactList.size()>0){
        delete contactList;
      }
}
}