trigger ContactActions on Contact (before insert,before update) {
    if(trigger.isBefore && trigger.isInsert){
       ContactTriggerHandler.preventCreatePrimaryContactOnInsert(trigger.new); 
    }
     if(trigger.isBefore && trigger.isUpdate){
         ContactTriggerHandler.preventPrimaryContactonUpdate(Trigger.NewMap , Trigger.OldMap);
}
      /* Map<Id,Account> accMap = new Map<Id,Account> ([Select Id,Name, (Select Id, name, PrimaryContact__c from Contacts) from Account
                                                 Where Id in (Select AccountId from Contact where Id in :Trigger.new)]);
    
    List<Contact> conList = [Select Id, AccountId, PrimaryContact__c from Contact where Id in :Trigger.new]; 
    
    for(Contact c: conList){
        if(c.PrimaryContact__c == true && accMap.get(c.AccountId).Contacts.size()>0){
            for(Contact c2:accMap.get(c.AccountId).Contacts){
                if(c2.PrimaryContact__c == true){
                    c.addError('Account Already Can\'t have more than one Primary Contact! Already have One!');                    
                }
            } 
       }
    }*/
}