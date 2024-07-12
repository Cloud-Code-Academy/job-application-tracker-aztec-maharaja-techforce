public with sharing class JobApplicationTriggerHandler extends TriggerHandler {

    private Map<Id,Job_Application__c> oldJobApplicationMap;

    public JobApplicationTriggerHandler(){
        this.oldJobApplicationMap = (Map<Id,Job_Application__c>) Trigger.oldMap;
    }

    public override void beforeInsert() {
        JobApplTriggerHelper jobApplTrigHelper = new JobApplTriggerHelper();
        jobApplTrigHelper.setPrimaryContact(Trigger.new);
        JobApplTriggerHelper.jobApplicationDupeCheck(Trigger.new);
    }

    public override void beforeUpdate(){
        // JobApplTriggerHelper jobApplTrigHelper = new JobApplTriggerHelper();
        JobApplTriggerHelper.updateDateApplied(Trigger.new, oldJobApplicationMap);
    }

}