public with sharing class JobApplicationTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        JobApplTriggerHelper jobApplTrigHelper = new JobApplTriggerHelper();
        jobApplTrigHelper.setPrimaryContact(Trigger.new);
    }
}