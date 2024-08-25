public with sharing class JoobleController {
    // public String body;
    @AuraEnabled(cacheable=true)
    public static List<Job> joobleCallout(String keyword, String location){
        try {
            String endpoint = 'https://jooble.org/api/d0022814-04ff-4313-afc3-534400904bb2';

            Http http = new Http();
            HttpRequest request = new HttpRequest();

            RequestBody requestBody = new RequestBody();
            requestBody.keywords = keyword;
            requestBody.location = location;
            // requestBody.resultonpage = 5;
            


            request.setHeader('Content-type', 'application/json');
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setBody(JSON.serialize(requestBody));

            HttpResponse response = http.send(request);
            String body = response.getBody();
            // System.debug(body);
            
            JobList allJobs = (JobList)JSON.deserialize(body, JobList.class);
            List<Job> individualJobs = getJobFromJobList(allJobs);
            // System.debug(allJobs.jobs);
            return individualJobs;
                
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Job> getJobFromJobList(JobList allJobs){
        List<Job> listOfIndividualJobs = new List<Job>();
       for(Job j : allJobs.jobs){
            listOfIndividualJobs.add(j);
       } 
       return listOfIndividualJobs;

    }

    public class RequestBody{
        public String keywords;
        public String location;
        // public Integer resultonpage;
    }


    public class JobList{
        // @AuraEnabled public Integer totalCount;
        @AuraEnabled public List<Job> jobs;        
    }

    public class Job{
        @AuraEnabled public String title;	
        @AuraEnabled public String location;	
        @AuraEnabled public String snippet;	
        @AuraEnabled public String salary;	
        @AuraEnabled public String source;	
        @AuraEnabled public String type;	
        @AuraEnabled public String link;	
        @AuraEnabled public String company;	
        @AuraEnabled public String updated;	
        @AuraEnabled public String id;	

    }

}