public with sharing class JobPostingHandler {

    @AuraEnabled
    public static Job_Posting__c searchForJobPostingByPostingId(String postId){
        List<Job_Posting__c> existingJobs = [SELECT Id FROM Job_Posting__c WHERE Posting_Id__c = :postId];

        if(existingJobs != null && existingJobs.size() > 0){
            return existingJobs[0];
        }else{
            return null;
        }

        
    }

    @AuraEnabled
    public static Job_Posting__c createJobPosting (String accountId, String jobPostingName, String description, String location, String postId, String salary){
        Job_Posting__c newJobPosting = new Job_Posting__c(  Name = jobPostingName, 
                                                            Account__c = accountId, 
                                                            Description__c = description, 
                                                            Location__c = location, 
                                                            Salary__c = salary, 
                                                            Posting_Id__c = postId);
        insert newJobPosting;
        return newJobPosting;
    }
}