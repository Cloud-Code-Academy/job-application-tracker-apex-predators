/*
* 
* JobApplicationTrigger will fire in the following circumstances:
* - after insert
* - before update
* - after update
* - after undelete
* 
* All logic and actions will be exeuted in the JobApplicationTriggerHandler.cls class
* 
*/

trigger JobApplicationTrigger on Job_Application__c (after insert, before update, after update, after undelete) {
    // Create an instance of the JobApplicationTriggerHandler and run it
    JobApplicationTriggerHandler jobAppTrigger = new JobApplicationTriggerHandler();
    jobAppTrigger.run();
}