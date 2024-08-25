@IsTest
public with sharing class AccountHandlerTest {

    @IsTest
    static void testCreateAccount(){
        Account newAccountId = AccountHandler.createAccount('Test Account');
        System.assertNotEquals(null, newAccountId, 'The new account ID should not be null');

        Account retrievedAccount = [SELECT Id, Name FROM Account WHERE Id = :newAccountId.Id];
        System.assertNotEquals(null, retrievedAccount, 'The retrieved account should not be null');
        System.assertEquals(newAccountId.Id, retrievedAccount.Id, 'The IDs should match');
    }   

    @IsTest
    static void testSearchForAccountByName(){
        Account testAccount = new Account(Name = 'Test');
        Account testAccount2 = new Account(Name = 'Test2');
        insert new List<Account>{testAccount,testAccount2};

        Account searchedAccount = AccountHandler.searchForAccountByName('Test');
        Assert.areEqual(testAccount.Id, searchedAccount.Id, 'The account should be the same');
        
    }
}