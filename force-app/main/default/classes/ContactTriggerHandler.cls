public class ContactTriggerHandler {
// prevent user to create primary contact if there is any existing primary contact
    public static void preventCreatePrimaryContactOnInsert(List<Contact> contactList){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Contact> accountIdContactMap = new Map<Id,Contact>();
        for(Contact contactObj : contactList){
            if(contactObj.PrimaryContact__c==true && contactObj.AccountID!=null){
                accountIdSet.add(contactObj.AccountID);
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){
//Preparation of map accountIdContactMap for existing primary contact
      for(Contact contObj : [select id,PrimaryContact__c,AccountId 
                             from Contact 
                             where AccountId in:accountIdSet and PrimaryContact__c=true]){
        accountIdContactMap.put(contObj.AccountId,contObj);
            }
//Validation Starts
            for(Contact contactObj : contactList){
              if(contactObj.PrimaryContact__c==true && contactObj.AccountID!=null &&
                 accountIdContactMap.get(contactObj.AccountId)!=null){
                 contactObj.addError('You cant create more than one primary contact');    
                 }
            }
        }
    }
    
 //Prevent user for having multiple primary contacts under an Account for UPDATE
    public static void preventPrimaryContactonUpdate(Map<Id,Contact> contactNewMap,Map<Id,Contact> contactOldMap){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Contact> accountIdContactMap = new Map<Id,Contact>();
        for(Contact contactObj:contactNewMap.values()){
            if(contactNewMap.get(contactObj.id).PrimaryContact__c!=contactOldMap.get(contactObj.Id).PrimaryContact__c 
                && contactNewMap.get(contactObj.id).PrimaryContact__c==true && contactNewMap.get(contactObj.id).AccountID!=null){               
                accountIdSet.add(contactNewMap.get(contactObj.id).AccountID);
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){   
            //Preparation of map accountIdContactMap for existing primary contact
            for(Contact contObj:[select id,PrimaryContact__c,AccountId from Contact 
                    where AccountId in:accountIdSet and PrimaryContact__c=true]){
                    accountIdContactMap.put(contObj.AccountId,contObj);
            }
            //Validation
            for(Contact contactObj:contactNewMap.values()){
                if(contactNewMap.get(contactObj.id).PrimaryContact__c!=contactOldMap.get(contactObj.Id).PrimaryContact__c 
                    && contactNewMap.get(contactObj.id).PrimaryContact__c==true 
                    && contactNewMap.get(contactObj.id).AccountID!=null 
                    && accountIdContactMap.get(contactNewMap.get(contactObj.id).AccountID)!=null){               
                        contactObj.addError('You can\'t make more than one contact as primary.');
                }
            }


        }

    }

}