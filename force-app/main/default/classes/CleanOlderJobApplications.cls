/*  
*   This Apex Schedulable class will be used to clean up Job Applications which older than N days and having status other than Closed or Accepted. 
*/

public with sharing class CleanOlderJobApplications  implements Schedulable {
    public CleanOlderJobApplications() {

    }
    // Query to find job applicatioins created x days ago.
    // Select Id from Job_Application__c where status__c != 'Closed' AND status__c != 'Accepted' AND createddate = N_Days_Ago:2 order by createddate desc LIMIT 100

    public void execute(SchedulableContext sc) {
        updateOlderJobApplications();
    }

    public static void updateOlderJobApplications() {
        List<Job_Application__c> olderJobs = [SELECT Id, Status__c, Date_Applied__c, createddate, (SELECT Id FROM Events WHERE Type = 'Meeting') FROM Job_Application__c WHERE status__c != 'Closed' AND status__c != 'Accepted' AND createddate = N_Days_Ago:1 LIMIT 2];
        for(Job_Application__c jobRec : olderJobs) {
            if(jobRec.Date_Applied__c == null) {
                jobRec.Date_Applied__c = jobRec.createddate.date();
            }

            jobRec.Status__c = 'Closed';
        }

        upsert olderJobs;

        JobApplHelper.sendExecutionStatusEmail('Job Application Cleanup', 'Stale Job Applications Cleanup Status', '# of Job Applications cleaned : ' + olderJobs.size(), null);
    }
}