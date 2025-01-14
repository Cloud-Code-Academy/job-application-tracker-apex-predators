public with sharing class JobParser {
    
    /**
     * Parses the JSON response from the Jooble job board and converts it into a list of Job_Application__c records.
     * @param jsonResponse The JSON response from the API.
     * @return A list of Job_Application__c records.
     */
    public static void parseJoobleApps(String jsonResponse){

        
        
        Map<String,Object> jsonMap = (Map<String,Object>) JSON.deserializeUntyped(jsonResponse);
        // If callout pulled back any jobs, iterate through to build Job Applications
        if(jsonMap.containsKey('jobs')){
            List<Object> jobs = (List<Object>) jsonMap.get('jobs');
            // Initialize containers for Account names and Job Application records
            Set<String> accNames = new Set<String>();
            List<Job_Application__c> jobApplicationList = new List<Job_Application__c>();
            
            for(Object jobObject : jobs){
                Map<String,Object> job = (Map<String,Object>) jobObject;
                // Create new Job_Application__c record from job
                Job_Application__c jobApp = new Job_Application__c();
                jobApp.Status__c = 'Saved';
                jobApp.Company_Name__c = (String)job.get('company');
                jobApp.Position_Title__c = (String)job.get('title');
                jobApp.Job_Posting_URL__c = (String)job.get('link');
                jobApp.Job_Description__c = (String)job.get('snippet');
                if(job.containsKey('salary') && !String.isEmpty((String)job.get('salary'))){
                    jobApp.Salary__c = Integer.valueOf((String)job.get('salary'));
                }
                accNames.add((String)job.get('company'));
                
            }
        }
    }
}