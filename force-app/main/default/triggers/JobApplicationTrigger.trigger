trigger JobApplicationTrigger on Job_Application__c (before insert, after insert, before delete, after delete, before update, after update, after undelete) {
    new JobApplicationTriggerHandler().run();

    // switch on Trigger.operationType {
    //     when  BEFORE_INSERT{
    //         JobApplicationTriggerHandler.beforeInsert(Trigger.new);
    //     }
    //     when BEFORE_UPDATE{
    //         JobApplicationTriggerHandler.updateDateApplied(Trigger.new, Trigger.oldMap);
    //     }
    // }
}