/**
 * InterviewScheduler
 * Schedules the InterviewReminderJob to run nightly at 2:00 AM.
 */
public with sharing class InterviewReminderJobScheduler implements Schedulable{
    
    /**
     * Kicks off the InterviewReminderJob when executed by the scheduler
     * @param sc The SchedulableContext
     */
    public void execute(SchedulableContext sc) {

        InterviewReminderJob.runJob();        
    }

    /**
     * Schedule the InterviewReminderJob
     */
    public static void scheduleJob(){

        String jobName = 'Interview Reminder Job';
        String cronExpression = '0 0 3 * * ?'; // 3:00 AM daily

        // Abort duplicate jobs if they exist
        for (CronTrigger ct : [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :jobName]){
            System.abortJob(ct.Id);
        }

        // Schedule the new job
        System.schedule(jobName, cronExpression, new InterviewReminderJobScheduler());
    }
}