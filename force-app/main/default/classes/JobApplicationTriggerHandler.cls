public with sharing class JobApplicationTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        JobApplTriggerHelper jobApplTrigHelper = new JobApplTriggerHelper();
        jobApplTrigHelper.setPrimaryContact(Trigger.new);
    }
}public with sharing class JobApplicationTriggerHandler {

    @AuraEnabled(cacheable=true)
    public static void beforeInsert(List<Job_Application__c> newJobApplications){
        List<Job_Application__c> duplicates = JobApplicationHandler.dupeCheck(newJobApplications);

        String errorMessage = 'You already saved this job.';
        AuraHandledException auraEx = new AuraHandledException(errorMessage);
        auraEx.setMessage(errorMessage);

        for(Job_Application__c dupe : duplicates){
            dupe.addError('You already saved this job.');
            throw auraEx;
        }


    }

    public static void updateDateApplied(List<Job_Application__c> newJobApplications, Map<Id,Job_Application__c> oldJobAppMap){
        for(Job_Application__c job : newJobApplications){
            if(job.Status__c == 'Applied' && oldJobAppMap.get(job.Id).Status__c != 'Applied'){
                job.Date_Applied__c = Date.today();
            }
        }
    }
}