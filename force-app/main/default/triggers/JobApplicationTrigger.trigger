trigger JobApplicationTrigger on Job_Application__c (before insert, after insert, before delete, after delete, before update, after update, after undelete) {
    new JobApplicationTriggerHandler().run();
}