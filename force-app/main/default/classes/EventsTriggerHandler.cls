public with sharing class EventsTriggerHandler extends TriggerHandler{
    public override void beforeInsert() {
        EventsTriggerHelper eth = new EventsTriggerHelper();
        eth.checkDuplicateEvent(Trigger.new);
    }
}