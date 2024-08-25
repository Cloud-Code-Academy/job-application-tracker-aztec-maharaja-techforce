/*  
*   This Apex Helper class will be used to perform multiple actions from LWC component.
*/

public with sharing class JobApplHelper {
    public JobApplHelper() {

    }

    /* This method will return all open jobs for the given Location */
    @AuraEnabled(cacheable=true)
    public static List<Job_Posting__c> getOpenJobs(String location) {
        String locationKey = '%' + location + '%';
        List<Job_Posting__c> jobPostingsList = [SELECT Id, Name, Company__r.Name, Location__c, Description__c, Department__c, Employment_Type__c,  Salary__c 
                FROM Job_Posting__c 
                WHERE Location__c LIKE :locationKey 
                AND Status__c = 'Open' 
                AND Salary__c != null
                ];
        
        for(Job_Posting__c jobPostingRec : jobPostingsList) {
            String[] salaryRange;
            if( (jobPostingRec.Salary__c).contains(' - ') && !(jobPostingRec.Salary__c).contains('per hour')) {
                salaryRange = jobPostingRec.Salary__c.split(' - ');
                if(!salaryRange[0].contains('.')) {
                    jobPostingRec.Salary__c = salaryRange[0].replace('k', '000');
                }
                else {
                    jobPostingRec.Salary__c = (salaryRange[0].replace('.','')).replace('k', '00');
                }
            }
            else if( (jobPostingRec.Salary__c).contains('per hour') ) {
                if(jobPostingRec.Salary__c.contains(' - ')) {
                    salaryRange = jobPostingRec.Salary__c.split(' - ');
                }
                else {
                    salaryRange = jobPostingRec.Salary__c.split(' per hour');
                 
                }
                if(!salaryRange[0].contains('.')) {
                    jobPostingRec.Salary__c = '$' + String.valueOf(Integer.valueOf(salaryRange[0].substringAfter('$'))* 2080);
                }
                else {
                    jobPostingRec.Salary__c = '$' + String.valueOf(Integer.valueOf(salaryRange[0].substringBetween('$', '.'))* 2080);
                }
            }
            else {
                if(!jobPostingRec.Salary__c.contains('.')) {
                    jobPostingRec.Salary__c = jobPostingRec.Salary__c.replace('k', '000');
                }
                else {
                    jobPostingRec.Salary__c = (jobPostingRec.Salary__c.replace('.', '')).replace('k', '00');
                }
            }
        }
        return jobPostingsList;
    }
    
    /* This method will check if the candidate has already registered in the system or not.  If registered, it will return the list of jobs applied by the candidate */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> isCandidateExistInSystem(String email) {
        Id contactId = [SELECT Id from Contact WHERE Email = :email AND Type__c = 'Job Applicant']?.Id;
        if(contactId != null) {
            return getJobsAppliedByCandidate(contactId);
        }
        return null;
    }

    /* This method will return all the jobs that were applied by the candidate having status other than Closed / Withdrawn / Accepted */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getJobsAppliedByCandidate(Id contactId) {
        List<Map<String, String>> jobsList = new List<Map<String, String>>();

        for(Job_Application__c jobRecord : [SELECT Id, Job_Posting__r.Name, Job_Posting__r.Company__r.Name, Date_Applied__c, Status__c from Job_Application__c 
                WHERE applicant_id__c = :contactId AND (Status__c != 'Closed' OR Status__c != 'Withdrawn' OR Status__c != 'Accepted')]) {
                    Map<String, String> jobsMap = new Map<String, String>();
                    jobsMap.put('Id', jobRecord.Id);
                    jobsMap.put('JobTitle', jobRecord.Job_Posting__r.Name);
                    jobsMap.put('CompanyName', jobRecord.Job_Posting__r.Company__r.Name);
                    jobsMap.put('DateApplied', String.valueOf(jobRecord.Date_Applied__c));
                    jobsMap.put('ApplicationStatus', jobRecord.Status__c);

                    jobsList.add(jobsMap);
                }
        return jobsList;
    }

    /* This method will save the job application based on the candidate's first name, last name, email */
    @AuraEnabled(cacheable=true)
    public static String saveJobApplication(String contactId, String firstName, String lastName, String emailId, Id jobPostingId){
        Contact contactRec;
        Job_Application__c jobApplication;

        try {
            if(contactId == null || String.isEmpty(contactId)) {
                contactRec = new Contact(FirstName = firstName, LastName = lastName, Email = emailId, Type__c = 'Job Applicant');
                upsert contactRec;
            }    
            
            jobApplication = new Job_Application__c(Applicant_Id__c = contactId ?? contactRec.Id, Job_Posting__c = jobPostingId, Status__c = 'Applied', Date_Applied__c = Date.today());
            upsert jobApplication;

            return jobApplication.Id;
         } catch (Exception e) {
            return 'Error occurred while saving job application record : ' + e.getMessage();
        }
    }

    /* This method will be used to send by 2 different components.
    *  1. JobApplDataSync and CleanOlderJobApplications schedulable classes to send the confirmation email to System Administrator after successful completion
    *  2. Job_Application_Screen Flow after successful insert of Job Application Record 
    */
    
    public static void sendExecutionStatusEmail(String mailContext, String subject, String body, String applicantEmail){
        if(String.isNotEmpty(mailContext) && (mailContext == 'Job Data Integration' || mailContext == 'Job Application Cleanup')) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{};
            for (User userRec : [SELECT Email  FROM User WHERE ProfileId in (SELECT Id FROM Profile WHERE Name = 'System Administrator') AND isActive = true]) {
                toAddresses.add(userRec.email);
            }
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});    
        }
        else if(String.isNotEmpty(mailContext) && mailContext == 'Job Application Submitted') {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{applicantEmail};
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            List<Messaging.SendEmailResult> sendResult = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});    
            if(sendResult != null ) {
                System.debug('Job Application Submission Mail has been sent : ' + sendResult);
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static void sendApplSubmissionEmail(String inputValues) {
        // System.debug('Input Values : ' + inputValues);
        List<Object> inValues = (List<Object>)JSON.deserializeUntyped(inputValues);
        String jobId = (String)((Map<String, Object>)inValues.get(0)).get('value');
        List<Job_Application__c> jobApplication = [SELECT Name, Job_Posting__r.Name, Job_Posting__r.Company__r.Name 
                                                    FROM Job_Application__c 
                                                    WHERE Job_Posting__c = :jobId 
                                                    ORDER BY createddate LIMIT 1];
        String[] jobName = jobApplication.get(0).Name.split(' - ');
        String applicantEmail = jobName[1];
        String jobTitle = jobApplication.get(0).Job_Posting__r.Name;
        String companyName = (String)jobApplication.get(0).Job_Posting__r.Company__r.Name;
        String emailBody = 'Hello \n\n Thank you for your interest in the ' + jobTitle + ' with ' + companyName + '.  ' +
                            'Your application has been successfully submitted and one of our recruiters will contact you shortly.\n\n' +
                            'Cheers,\n ' + companyName + ' Recruiting Team';
        
        sendExecutionStatusEmail('Job Application Submitted', 'Your application has been submitted', emailBody, applicantEmail);
    }
}