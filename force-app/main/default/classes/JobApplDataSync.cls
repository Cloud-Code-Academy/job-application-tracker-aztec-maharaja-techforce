public with sharing class JobApplDataSync implements Schedulable{
    public static Boolean EXCEPTION_OCCURRED = false;

    public void execute(SchedulableContext sc) {
        syncDataFromJobBoard('Jooble');
    }


    @future(callout = true)
    public static void syncDataFromJobBoard(String jobBoardName) {
        String urlName = '';
        String apiKey = '';
        List<Job_Post_Integration__mdt> jobBoardAPIKey = getJobBoardAPIKey(jobBoardName);
        if(jobBoardAPIKey.size() == 0) {
            System.debug('No API Key found for the given Job Board : ' + jobBoardName);
        }
        else {
            urlName = jobBoardAPIKey.get(0).API_Name__c;
            apiKey = jobBoardAPIKey.get(0).API_Key__c;
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint('https://' + urlName + '/api/' + apiKey);
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type', 'application/json;charset=utf-8');
            String requestPayLoad = generateRequestPayLoad('Designer', 'USA', '2024-06-08', 50, '120000');  //keywords, location, datecreatedfrom, resultonpage, salary
            httpRequest.setBody(requestPayLoad);
            httpRequest.setHeader('Connection','keep-alive');
            httpRequest.setTimeout(120000);
            Http http = new Http();
            try {
                HttpResponse response = http.send(httpRequest);
                if(response.getStatusCode() == 200) {
                    String responseData = response.getBody();
                    Map<String, Object> jsonResponseMap = (Map<String, Object>)JSON.deserializeUntyped(responseData);
                    List<Object> jobDataList = (List<Object>)jsonResponseMap.get('jobs');
                    parseJobData(jobBoardName, JSON.serialize(jsonResponseMap.get('jobs')));
                }
            }
            catch(Exception ex) {
                EXCEPTION_OCCURRED = true;
                JobApplHelper.sendExecutionStatusEmail('Job Data Integration', 'Jooble Job Data Sync Job Status', 'Execution of job sync failed with error : ' + ex.getMessage(), null);
            }
            finally{
                if(!EXCEPTION_OCCURRED) {
                    JobApplHelper.sendExecutionStatusEmail('Job Data Integration', 'Jooble Job Data Sync Job Status', 'Job Posting Data has been updated successfully : ' + '\n\n', null);
                }
            }
        }
    }

    private static List<Job_Post_Integration__mdt> getJobBoardAPIKey(String jobBoard) {
        return [SELECT API_Name__c, API_Key__c FROM Job_Post_Integration__mdt WHERE DeveloperName = :jobBoard];
    }

    private static String generateRequestPayLoad(String keywords, String location, String datecreatedfrom, Integer resultonpage, String salary) {
        JooblePayLoad payLoad = new JooblePayLoad();
        payLoad.keywords = keywords;
        payLoad.location = location;
        payLoad.datecreatedfrom = datecreatedfrom;
        payLoad.resultonpage = resultonpage;
        payLoad.salary = salary;

        return JSON.serialize(payLoad);
    }

    private static void parseJobData(String jobBoardName, String jobData) {
        List<Object> jobDataList = (List<Object>)JSON.deserializeUntyped(jobData);
        //  Keys : company, id, link, location, salary, snippet, source, title, type, updated
        Set<String> companySet = new Set<String>();
        List<Account> companyData = new List<Account>();
        List<Job_Posting__c> jobPostingsList = new List<Job_Posting__c>();

        for(Object jobDataDetails : jobDataList) {
            Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(jobDataDetails));
            companySet.add((String)dataMap.get('company'));    
        }        

        Map<String, Account> companyByIdMap = new Map<String, Account>();
        List<Job_Posting__c> jobReferenceIdList = new List<Job_Posting__c>();

        for(Account acc : [SELECT Id, Name, (SELECT Job_Reference_Id__c FROM Job_Postings__r) FROM Account WHERE Type = 'Job Posts']) {
            companyByIdMap.put(acc.Name, acc);
            if(acc.Job_Postings__r != null && acc.Job_Postings__r.size() == 1) {
                jobReferenceIdList.add(acc.Job_Postings__r);
            }
            else {
                for(Job_Posting__c jpr : acc.Job_Postings__r) {
                    jobReferenceIdList.add(jpr);
                }
            }
        }

        for(String companyName : companySet) {
            if(String.isNotBlank(companyName) && String.isNotEmpty(companyName)){
            if(companyByIdMap.containsKey(companyName)) {
                companyData.add(companyByIdMap.get(companyName));
            }
            else {
                companyData.add(new Account(Name = companyName, Type = 'Job Posts'));
            }
        }
        }

        upsert companyData;

        for(Account acc : companyData) {
            if(!companyByIdMap.containsKey(acc.Name)) {
                companyByIdMap.put(acc.Name, acc);
            }
        }

        List<String> jobRefIdList = new List<String>();
        for (Job_Posting__c postingData : jobReferenceIdList) {
            jobRefIdList.add(postingData.Job_Reference_Id__c);
        }

        for(Object jobDataDetails : jobDataList) {
            Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(jobDataDetails));
            if(dataMap.get('company') != null && jobRefIdList != null && jobRefIdList.size() > 0 && !jobRefIdList.contains(String.valueOf(dataMap.get('id')))) {
                String company = (String)dataMap.get('company');
                String department = 'IT';
                Date datePosted = Date.valueOf((String)dataMap.get('updated') ?? '2024-06-12');
                String description = (String)dataMap.get('snippet') ?? 'No Snippet Available';
                String employmentType;      // Full-time, Temporary, Part-time
                if((String)dataMap.get('type') == 'Full-time') {
                    employmentType = 'Full Time';
                }
                else if((String)dataMap.get('type') == 'Part-time') {
                    employmentType = 'Part Time';
                }
                else {
                    employmentType = 'Temporary';
                }
                String title = (String)dataMap.get('title') ?? 'Unknown Title';
                String referenceId;
                if(dataMap.get('id') != null) {
                    referenceId = String.valueOf(dataMap.get('id'));
                }
                else {
                    referenceId = null;
                }
                String location = (String)dataMap.get('location') ?? 'Unknown Location';
                String salary = (String)dataMap.get('salary') ?? '$125K';
                String status = 'Open';
                String link = (String)dataMap.get('link') ?? 'https://jooble.org';

                Job_Posting__c jobPosting = new Job_Posting__c(Company__c = companyByIdMap.get(company).Id, Department__c = department, Description__c = description,
                                                                Date_Posted__c = datePosted, Employment_Type__c = employmentType, Name = title, Job_Reference_Id__c = referenceId, Link__c = link, Location__c = location,
                                                                Salary__c = salary, Status__c = status);
                jobPostingsList.add(jobPosting);
            }
        } 

        upsert jobPostingsList;
    }

    private class JooblePayload {
        String keywords;
        String location;
        String datecreatedfrom;
        Integer resultonpage;
        String salary;
    }
}