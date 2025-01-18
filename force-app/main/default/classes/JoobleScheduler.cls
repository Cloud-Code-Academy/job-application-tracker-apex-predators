public with sharing class JoobleScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        JoobleCallout job = new JoobleCallout('Salesforce developer administrator', 'Remote', 1);
        System.enqueueJob(job);
    }

    public static void scheduleJob(){
        String jobName = 'Nightly Jooble Callout';
        String cronExpression = '0 0 0 * * ?';
    }
}