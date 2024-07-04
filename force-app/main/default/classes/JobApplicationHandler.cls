public with sharing class JobApplicationHandler {

    public static List<Job_Application__c> dupeCheck(List<Job_Application__c> newJobApplications){
        Set<Id> jobPostIds = new Set<Id>();
        Set<Id> candidateIds = new Set<Id>();

        for(Job_Application__c jobApplication : newJobApplications){
            jobPostIds.add(jobApplication.Job_Posting__c);
            candidateIds.add(jobApplication.Candidate__c);
        }

        List<Job_Application__c> existingJobApplications = [SELECT Id, Candidate__c, Job_Posting__c 
                                                            FROM Job_Application__c 
                                                            WHERE Candidate__c IN :candidateIds 
                                                            AND Job_Posting__c IN :jobPostIds];

        Map<Id,Set<Id>> mapOfExistingApplications = new Map<Id,Set<Id>>();

        if(existingJobApplications != null && existingJobApplications.size() > 0){

            for(Job_Application__c jobApplication : existingJobApplications){

                String jobPostId = jobApplication.Job_Posting__c;
                String candidateId = jobApplication.Candidate__c;

                if(!mapOfExistingApplications.containsKey(jobPostId)){
                    mapOfExistingApplications.put(jobPostId, new Set<Id>());
                }

                Set<Id> allCandidateIds = mapOfExistingApplications.get(jobPostId);
                allCandidateIds.add(candidateId);

                mapOfExistingApplications.put(jobPostId, allCandidateIds);

            }
        }

        List<Job_Application__c> duplicateRecords = new List<Job_Application__c>();

        for(Job_Application__c jobApp : newJobApplications){
            if(mapOfExistingApplications.containsKey(jobApp.Job_Posting__c) && mapOfExistingApplications.get(jobApp.Job_Posting__c).contains(jobApp.Candidate__c)){
                duplicateRecords.add(jobApp);
            }
        }
        return duplicateRecords;
    }
}