trigger EventsTrigger on Event (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new EventsTriggerHandler().run();
}