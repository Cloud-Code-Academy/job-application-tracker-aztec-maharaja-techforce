@IsTest
public with sharing class JobPostingHandlerTest {

    @IsTest
    static void testSearchForJobPostingByPostingId(){

        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Job_Posting__c jp = new Job_Posting__c(Name = 'Test', Posting_Id__c = '12345', Company__c = acc.Id);
        insert jp;

        Job_Posting__c retrievedJP = JobPostingHandler.searchForJobPostingByPostingId('12345');

        System.assertNotEquals(null, retrievedJP, 'The retrieved job posting should not be null');
        System.assertEquals(jp.Id, retrievedJP.Id, 'The IDs should match');
    
    }

    @IsTest
    static void testCreateJobPosting(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Job_Posting__c jp = JobPostingHandler.createJobPosting(acc.Id, 'Test Posting', 'Test Job Description', 'Miami', '12345', '120000');

        Job_Posting__c searchJp = [SELECT Id FROM Job_Posting__c WHERE Id = :jp.Id];

        System.assertNotEquals(null, searchJp, 'The new job posting should not be null');
        System.assertEquals(jp.Id, searchJp.Id, 'The IDs should match');

        System.assertNotEquals(null, jp, 'The new job posting should not be null');
        System.assertEquals(acc.Id, jp.Company__c, 'The job posting should be associated with the correct account');
    
    }
}