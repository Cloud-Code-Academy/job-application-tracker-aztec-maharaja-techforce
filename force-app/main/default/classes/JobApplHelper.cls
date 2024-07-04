public with sharing class JobApplHelper {
    public JobApplHelper() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Job_Posting__c> getOpenJobs(String location) {
        String locationKey = '%' + location + '%';
        List<Job_Posting__c> jobPostingsList = [SELECT Id, Name, Company__r.Name, Location__c, Description__c, Department__c, Employment_Type__c,  Salary__c 
                FROM Job_Posting__c 
                WHERE Location__c LIKE :locationKey 
                AND Status__c = 'Open' ];
        
        for(Job_Posting__c jobPostingRec : jobPostingsList) {
            String[] salaryRange;
            if( (jobPostingRec.Salary__c).contains(' - ') && !(jobPostingRec.Salary__c).contains('per hour')) {
                salaryRange = jobPostingRec.Salary__c.split(' - ');
                jobPostingRec.Salary__c = salaryRange[0].replace('k', '000');
            }
            else if( (jobPostingRec.Salary__c).contains('per hour') ) {
                if(jobPostingRec.Salary__c.contains(' - ')) {
                    salaryRange = jobPostingRec.Salary__c.split(' - ');
                }
                else {
                    salaryRange = jobPostingRec.Salary__c.split(' per hour');
                }
                jobPostingRec.Salary__c = '$' + String.valueOf(Integer.valueOf(salaryRange[0].substringAfter('$'))* 2080);
            }
            else {
                jobPostingRec.Salary__c = jobPostingRec.Salary__c.replace('k', '000');
            }
        }
        return jobPostingsList;
    }
    
    @AuraEnabled(cacheable=true)
    public static Id isCandidateExistInSystem(String email) {
        return [SELECT Id from Contact WHERE Email = :email AND Type__c = 'Job Applicant']?.Id;
    }

    @AuraEnabled(cacheable=true)
    public static List<Job_Application__c> getJobsAppliedByCandidate(Id contactId) {
        return [SELECT Job_Posting__c, Applicant_Id__c, Status__c, Job_Posting__r.Name from Job_Application__c];
    }

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