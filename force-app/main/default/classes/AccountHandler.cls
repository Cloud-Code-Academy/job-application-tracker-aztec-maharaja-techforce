public with sharing class AccountHandler {

    @AuraEnabled
    public static Account searchForAccountByName(String name){
        List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :name];

        if(existingAccounts != null && existingAccounts.size() > 0 ){
            return existingAccounts[0];
        } else {
            // return new Account();
            return null;
        }
    }

    @AuraEnabled
    public static Account createAccount(String name){
        Account newAccount = new Account(Name = name);
        insert newAccount;
        return newAccount;
    }

}