@IsTest
public with sharing class AccountHandlerTest {
    
    @IsTest
    public void testCreateAccount(){
        Id newAccountId = AccountHandler.createAccount('Test Account');
        System.assertNotEquals(null, newAccountId, 'The new account ID should not be null');

        Account retrievedAccount = [SELECT Id, Name FROM Account WHERE Id = :newAccountId];
        System.assertNotEquals(null, retrievedAccount, 'The retrieved account should not be null');
        System.assertEquals(newAccountId, retrievedAccount.Id, 'The IDs should match');
    }
}