public with sharing class ContactHandler {

    @AuraEnabled
    public static Contact searchForCandidateByEmail(String email){
        List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email = :email];

        if(existingContacts != null && existingContacts.size() > 0){
            return existingContacts[0];
        }else{
            return null;
        }
    }

    @AuraEnabled
    public static Contact createCandidate(String firstName, String lastName, String email){
        Contact newContact = new Contact(FirstName = firstName, LastName = lastName, Email = email, Type__c = 'Job Applicant');
        insert newContact;
        return newContact;
    }
}