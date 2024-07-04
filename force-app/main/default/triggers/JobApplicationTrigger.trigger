trigger JobApplicationTrigger on Job_Application__c (before insert, before update) {
    switch on Trigger.operationType {
        when  BEFORE_INSERT{
            JobApplicationTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE{
            JobApplicationTriggerHandler.updateDateApplied(Trigger.new, Trigger.oldMap);
        }
    }
}