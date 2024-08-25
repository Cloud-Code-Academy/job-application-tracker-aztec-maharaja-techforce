@IsTest
public with sharing class JobApplicationHandlerTest {


    @IsTest
    static void testDuplicateJobApplicationCheck(){

        List<SObject> recordsToInsert = new List<SObject>();

        Account newAccount = new Account(
            Name = 'Test Company'
        );
        // insert newAccount;
        recordsToInsert.add(newAccount);

        Contact newContact = new Contact(
            FirstName = 'Test',
            LastName = 'Candidate',
            Email = 'test.candidate@test.com'
        );
        // insert newContact;
        recordsToInsert.add(newContact);
        insert recordsToInsert;

        Job_Posting__c newJobPosting = new Job_Posting__c(
            Name = 'Test Job Posting',
            Posting_Id__c = '12345',
            Company__c = newAccount.Id,
            Salary__c = '.00 - ,000.00'
        );
        insert newJobPosting;
        
        

        List<Job_Application__c> newJobApplications = new List<Job_Application__c>();
        
        for(Integer i = 0; i < 2; i++) {
            Job_Application__c newJobApplication = new Job_Application__c(
                Name = 'Test Job Application' + i,
                Status__c = 'Saved',
                Job_Posting__c = newJobPosting.Id,
                Applicant_Id__c = newContact.Id,
                Date_Applied__c = System.today()
        );
        
            newJobApplications.add(newJobApplication);
            
       }

       insert newJobApplications;

        Test.startTest();
        List<Job_Application__c> duplicateRecords = JobApplicationHandler.dupeCheck(newJobApplications);
        Test.stopTest();

        System.assertEquals(2, duplicateRecords.size());
        // System.assertEquals(, duplicateRecords[0].Id);



        

    


        


        
    }

}