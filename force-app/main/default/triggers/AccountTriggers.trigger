trigger AccountTriggers on Account (before insert , after insert, before update, after update) {
/*Before trigger = same object record
After trigger = other object records*/
    
    
    /*scenario 1
When user creates Account record by giving shipping address populate same on billing address
Logic = Insert
Event = Before*/
    if(trigger.isBefore && trigger.isInsert){
        for(Account accRec : Trigger.new){
 /*Scenario 2 
   Throw error when user creates record if Annual REvenue less than 1000*/
            if(accRec.AnnualRevenue<1000){
                accRec.addError('Annual Revenue cannot be less than 1000');
            }
    if(accRec.ShippingCity==null){
     accRec.shippingCity = accRec.BillingCity;}
     if(accRec.shippingCountry==null){
      accRec.shippingCountry = accRec.BillingCountry;}
                }
            }
/*Scenario 3
 When user creates an Account , create contact with same name and associate account and contact
*/
    if(trigger.isAfter && trigger.isInsert){
        List<contact> conListToInsert = new List<contact>();
        for(Account accRec : Trigger.New){
            contact con = new contact();
            con.LastName = accRec.Name;
            con.AccountId = accRec.Id;
            conListToInsert.add(con);
        }
     if(conListToInsert.size()>0)
         Insert conListToInsert;
    }  
 /*Scenario 4
 When user updates Account record, if user changes account name throw an error
account name once created cannot be modified
Logic = Update
Event = Before
*/   
    if(trigger.isBefore && trigger.isUpdate){
        system.debug('new values');
         system.debug(Trigger.New);
         system.debug(Trigger.newMap);
         system.debug('old values');
         system.debug(Trigger.Old);
         system.debug(Trigger.oldMap);
        
        
        for(Account accRecNew : Trigger.New){
           Account accRecOld = Trigger.oldMap.get(accRecNew.Id);
            if(accRecNew.Name!=accRecOld.Name){
                accRecNew.addError('Account Name cannot be modified once it is created');
            }
        }
    
    }
 /*Scenario 5
 When user updates Account rec billing address then populate same on child contact mailing address
Logic = Update
Event = After*/
    if(trigger.isUpdate && trigger.isAfter){
       Set<Id> accIdsWhichGotBillingAddresChanged = new Set<Id>();        
        for(Account accRecNew : Trigger.New){
            Account accRecOld = Trigger.OldMap.get(accRecNew.Id);
            if(accRecNew.BillingStreet!=accRecOld.BillingStreet){
                accIdsWhichGotBillingAddresChanged.add(accRecNew.Id);
            }
  List<Account> accsWithContacts = [SELECT Id, Name,BillingStreet,BillingCity,BillingCountry,(Select id,name from contacts) 
                                     FROM Account
                                    WHERE Id IN:accIdsWhichGotBillingAddresChanged];
      List<contact> conListToUpdate = new List<contact>(); 
            for(Account acc : accsWithContacts){
                 List<contact> consOfTheLoopedAccount = acc.contacts;
                for(contact con :consOfTheLoopedAccount){
                    con.MailingCity = acc.BillingCity;
                    con.MailingCountry = acc.BillingCountry;
                    con.MailingStreet = acc.BillingStreet;
                  conListToUpdate.add(con);  
                }
            }
            Update conListToUpdate;
        }
    }
 /*Scenario 6
  Add related opportunity for each new or updated account if no opportunity is already associated with the account
    */
    if(Trigger.isUpdate && Trigger.isInsert){
    List<Opportunity> oppList = new List<Opportunity>();
    
    // Get the related opportunities for the accounts in this trigger
    Map<Id,Account> acctsWithOpps = new Map<Id,Account>(
        [SELECT Id,(SELECT Id FROM Opportunities) FROM Account WHERE Id IN :Trigger.New]);
    
    // Add an opportunity for each account if it doesn't already have one.
    // Iterate through each account.
    for(Account a : Trigger.New) {
        System.debug('acctsWithOpps.get(a.Id).Opportunities.size()=' + acctsWithOpps.get(a.Id).Opportunities.size());
        // Check if the account already has a related opportunity.
        if (acctsWithOpps.get(a.Id).Opportunities.size() == 0) {
            // If it doesn't, add a default opportunity
            oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=a.Id));
        }           
    }
    if (oppList.size() > 0) {
        insert oppList;
    }
    
    }
    
    
}