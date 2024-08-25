public with sharing class JobApplTriggerHelper {
    public void setPrimaryContact(List<SObject> objectList) {
        Map<Id, Id> companyIdMapByJobPostingId = new Map<Id, Id>();
        List<Id> jobPostingIdList = new List<Id>();

        for(Job_Application__c jobPostingRec : (List<Job_Application__c>)objectList) {
            jobPostingIdList.add(jobPostingRec.Job_Posting__c);
        }

        for(Job_Posting__c jobPostRec : [SELECT Id, Company__c  FROM Job_Posting__c WHERE Id in :jobPostingIdList]) {
            companyIdMapByJobPostingId.put(jobPostRec.Id, jobPostRec.Company__c);
        }

        Map<Id, List<Contact>> contactsMapByCompanyId = new Map<Id, List<Contact>>();
        
        for(Account acctRec : [SELECT Id,  (SELECT Id, Name, Type__c FROM Contacts WHERE Type__c = 'Hiring Manager' OR Type__c = 'Recruiter') 
                                                                FROM Account WHERE Id in :companyIdMapByJobPostingId.values() AND Type = 'Job Posts']) {
                contactsMapByCompanyId.put(acctRec.id, acctRec.Contacts);
        }

        for(Job_Application__c jobApplRec : (List<Job_Application__c>)objectList) {
            List<Contact> contactList = (List<Contact>)contactsMapByCompanyId.get(companyIdMapByJobPostingId.get(jobApplRec.Job_Posting__c));
            if(contactList != null && contactList.size() > 0) {
                jobApplRec.Primary_Contact__c = contactList.get(0).Id;
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static void jobApplicationDupeCheck(List<Job_Application__c> newJobApplications){
        List<Job_Application__c> duplicates = JobApplicationHandler.dupeCheck(newJobApplications);

        String errorMessage = 'You already saved this job.';
        AuraHandledException auraEx = new AuraHandledException(errorMessage);
        auraEx.setMessage(errorMessage);

        for(Job_Application__c dupe : duplicates){
            dupe.addError('You already saved this job.');
            throw auraEx;
        }

    }

    public static void updateDateApplied(List<SObject> newJobApplications, Map<Id,Job_Application__c> oldJobAppMap){
        for(Job_Application__c job : (List<Job_Application__c>)newJobApplications){
            if(job.Status__c == 'Applied' && oldJobAppMap.get(job.Id).Status__c != 'Applied'){
                job.Date_Applied__c = Date.today();
            }
        }
    }
}

