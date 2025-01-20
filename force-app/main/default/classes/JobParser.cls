public with sharing class JobParser {
    
    /**
     * Parses the JSON response from the Jooble job board and converts it into a list of Job_Application__c records.
     * @param jsonResponse The JSON response from the API.
     * @return A list of Job_Application__c records.
     */
    public static void parseJoobleApps(String jsonResponseBody){

        
        
        Map<String,Object> jsonMap = (Map<String,Object>) JSON.deserializeUntyped(jsonResponseBody);
        // If callout pulled back any jobs, iterate through to build Job Applications
        if(jsonMap.containsKey('jobs')){
            List<Object> jobs = (List<Object>) jsonMap.get('jobs');
            // Initialize containers for Account names and Job Application records
            Set<String> companyNames = new Set<String>();
            List<Job_Application__c> jobApplications = new List<Job_Application__c>();
            
            for(Object jobObject : jobs){
                Map<String,Object> job = (Map<String,Object>) jobObject;
                // Reject Jobs with null or blank company names
                if(String.isBlank((String)job.get('company'))){
                    continue;
                }
                // Create new Job_Application__c record from job
                Job_Application__c jobApp = new Job_Application__c();
                jobApp.Status__c = 'Saved';
                jobApp.Company_Name__c = (String)job.get('company');
                jobApp.Position_Title__c = (String)job.get('title');
                jobApp.Job_Posting_URL__c = (String)job.get('link');
                // Clean Job Description Snippet of HTML tags and entities and set jobApp job description field
                String rawSnippet = (String)job.get('snippet');
                jobApp.Job_Description__c = rawSnippet
                    .replaceAll('<.*?>',' ')
                    .replaceAll('&amp;', ' ')
                    .replaceAll('&nbsp;', ' ')
                    .replaceAll('&lt;',' ')
                    .replaceAll('&gt;',' ')
                    .normalizeSpace();

                // Set salary only if present and valid
                if(job.containsKey('salary') && !String.isBlank((String)job.get('salary'))){
                   // jobApp.Salary__c = (Decimal)Integer.valueOf((String)job.get('salary'));                    
                    jobApp.Salary_Text__c = (String)job.get('salary');                    
                }
                companyNames.add((String)job.get('company'));
                jobApplications.add(jobApp);
                
            }
            JobApplicationService.processJobApplications(companyNames, jobApplications);
        }
    }
}