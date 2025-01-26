trigger JobApplicationTrigger on Job_Application__c (after insert, before update, after update, after undelete) {
    // Create an instance of the JobApplicationTriggerHandler and run it
    JobApplicationTriggerHandler jobAppTrigger = new JobApplicationTriggerHandler();
    jobAppTrigger.run();
}