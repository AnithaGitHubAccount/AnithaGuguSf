public class AccountContactHandler {
public static void createDefaultContactForAccount(Map<Id,Account> accountNewMap){
     List<Contact> conList = new List<Contact>();
        List<Account> accList = [select Id,Name from Account where Id IN:accountNewMap.keyset()];
    for(Account acc : accList){
        
    }
    
}    
}