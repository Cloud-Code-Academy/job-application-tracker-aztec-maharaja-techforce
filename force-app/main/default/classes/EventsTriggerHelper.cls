public with sharing class EventsTriggerHelper {
    public void checkDuplicateEvent(List<SObject> objectList) {
        if(objectList != null && objectList.size() > 0) {
            Event newEventRec = ((List<Event>)objectList).get(0);
            String jobPostingId = newEventRec.WhatId;
            String jobApplicantId = newEventRec.WhoId;
            Datetime startDate = Datetime.valueOf(newEventRec.StartDateTime);
            Datetime endDate = Datetime.valueOf(newEventRec.EndDateTime);

            for(Event existingEventRec : [SELECT Id, WhatId, StartDateTime, EndDatetime FROM Event
                                    WHERE WhatId = :jobPostingId]) {
                if((startDate >= existingEventRec.StartDateTime && startDate < existingEventRec.EndDateTime) 
                    || (endDate > existingEventRec.StartDateTime && endDate < existingEventRec.EndDatetime)) {      
                        newEventRec.StartDateTime.addError(Label.Duplicate_Event_Error);
                }
            }
        }       
    }
}