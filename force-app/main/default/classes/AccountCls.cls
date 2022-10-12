public with sharing class AccountCls {
    public Account actObj{get;set;}
    public AccountCls() {
        actObj = new Account();
    }
    //Adding comment to test repository
    //Addedchanes
    public pagereference saveAccount(){
        insert actObj;
        return new pagereference('/'+actObj.Id);
    }
    @AuraEnabled (cacheable=true)
    public static List<Account> getAccountList(){
        return[SELECT Id, Name,Type,Industry,AnnualRevenue
                FROM Account where Industry!=null and AnnualRevenue!=null];
    }
}