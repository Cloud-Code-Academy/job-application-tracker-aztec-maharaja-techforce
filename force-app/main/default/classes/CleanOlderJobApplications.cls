public with sharing class CleanOlderJobApplications  implements Schedulable {
    public CleanOlderJobApplications() {

    }
    // Query to find job applicatioins created x days ago.
    // Select Id from Job_Application__c where status__c != 'Closed' AND status__c != 'Accepted' AND createddate = N_Days_Ago:2 order by createddate desc LIMIT 100

    public void execute(SchedulableContext sc) {
        updateOlderJobApplications();
    }

    public static void updateOlderJobApplications() {
        List<Job_Application__c> olderJobs = [SELECT Id, Status__c, (SELECT Id FROM Events WHERE Type = 'Meeting') FROM Job_Application__c WHERE status__c != 'Closed' AND status__c != 'Accepted' AND createddate = N_Days_Ago:2 LIMIT 2];
        for(Job_Application__c jobRec : olderJobs) {
            jobRec.Status__c = 'Closed';
        }

        upsert olderJobs;

        JobApplHelper.sendExecutionStatusEmail('Job Application Cleanup', 'Stale Job Applications Cleanup Status', '# of Job Applications cleaned : ' + olderJobs.size(), null);
    }
}