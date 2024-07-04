@isTest
public with sharing class JobApplHelperTest {
    public JobApplHelperTest() {

    }

    @isTest
    public static void testSendApplSubmissionEmail() {

        Account accountRec = new Account(Name='Test Hiring Company', Type='Job Posts');
        insert accountRec;

        Contact contactRec = new Contact(FirstName = 'Test', LastName = 'Name', Email = 'snk.95330@gmail.com', Type__c = 'Job Applicant');
        insert contactRec;
        Contact recruiterContact = new Contact(FirstName = 'Hiring Recruiter', LastName = 'Testing', Email = 'abc@xyz.com', Type__c = 'Recruiter', AccountId = accountRec.Id);
        insert recruiterContact;

        Job_Posting__c jobPostingRec = new Job_Posting__c(Company__c = accountRec.Id, Department__c = 'IT', Description__c = 'Test Job',
                                                                Date_Posted__c = Date.today(), Employment_Type__c = 'Full Time', Name = 'Senior Salesforce Developer', 
                                                                Job_Reference_Id__c = '-3886322937462864', Link__c = 'www.linkedin.com', Location__c = 'San Francisco, CA',
                                                                Salary__c = '$180K', Status__c = 'Open');

        insert jobPostingRec;

        Job_Application__c jobApplicationRec = new Job_Application__c(Applicant_Id__c = contactRec.Id, Job_Posting__c = jobPostingRec.Id, Status__c = 'Applied', Date_Applied__c = Date.today(), Name = jobPostingRec.Id + ' - ' + contactRec.Email);
        insert jobApplicationRec;

        Map<String, String> inputVariables = new Map<String, String>();
        inputVariables.put('value', jobPostingRec.Id);

        List<Map<String, String>> listObj = new List<Map<String, String>>();
        listObj.add(inputVariables);
        
        String jsonString = JSON.serialize(listObj);
        

        Test.startTest();
        JobApplHelper.sendApplSubmissionEmail(jsonString);
        Test.stopTest();

        Job_Application__c appl = [SELECT Id, Primary_Contact__c FROM Job_Application__c WHERE Id = :jobApplicationRec.Id];

        System.assertEquals(recruiterContact.Id, appl.Primary_Contact__c, 'Primary Contact was not set correctly');
    }

    @isTest
    public static void testIsCandidateExistInSystem() {
        Contact contactRec = new Contact(FirstName = 'Test', LastName = 'User', Email = 'test@test.com');
        insert contactRec;
        Test.startTest();
        Id contactId = JobApplHelper.isCandidateExistInSystem(contactRec.Email);
        Test.stopTest();
        System.assertEquals(null, contactId, 'Expected Id of the contact to be returned');
    }
}