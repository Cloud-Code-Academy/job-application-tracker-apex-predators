public with sharing class JoobleScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        JoobleCallout job = new JoobleCallout('Salesforce developer administrator', 'Remote', 1);
        System.enqueueJob(job);
    }

    // Schedule the job to run nightly
    public static void scheduleJob(){
        String jobName = 'Nightly Jooble Callout';
        String cronExpression = '0 0 0 * * ?'; // every night at midnight
        
        // Check if a job with this name is already scheduled
        for(CronTrigger ct : [Select Id FROM CronTrigger WHERE CronJobDetail.Name = :jobName]) {
            System.abortJob(ct.Id);  // Abort existing duplicated job
        }
        
        // Schedule new job
        System.schedule(JobName, cronExpression, new JoobleScheduler());
    }
}