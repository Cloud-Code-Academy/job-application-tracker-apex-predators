/*
* 
* The JobApplicationTriggerHandler class executes the following actions:
* 
* - Before Update:
*    - setPrimaryContacts: use associated Application Contact records to 
*         ensure records have a Primary Contact
* 
* - After Insert:
*   - createTasks: create tasks whenever the status of an application changes
*   - createAppContact: when Primary Contact is set or updated, make sure there
*         is an Application Contact record for that Contact and Application
* 
* - After Update:
*   - createTasks: create tasks whenever the status of an application changes
*   - createAppContact: when Primary Contact is set or updated, make sure there
*         is an Application Contact record for that Contact and Application
* 
* After Undelete:
*    - setPrimaryContacts: use associated Application Contact records to 
*         ensure records have a Primary Contact
* 
*/
public with sharing class JobApplicationTriggerHandler extends TriggerHandler{
    // Create class variables
    private List<Job_Application__c> newList;
    private Map<Id, Job_Application__c> oldMap;

    // Constructor sets the Trigger context variables to the correct SObject type
    public JobApplicationTriggerHandler() {
        this.newList = (List<Job_Application__c>)Trigger.new;
        this.oldMap = (Map<Id,Job_Application__c>)Trigger.oldMap;
    }

    /*
    * 
    * Before Save Methods
    * 
    */
    
    // Before Update method sets Primary Contact if it is null
    public override void beforeUpdate() {
        JobApplicationUtils.setPrimaryContacts(newList);
    }

    /*
    * 
    * After Save Methods
    * 
    */
    
    // After Insert methods create Tasks and App Contact related records
    public override void afterInsert() {
        JobApplicationUtils.createTasks(newList);
        JobApplicationUtils.createAppContact(newList);
    }

    // After Update methods create Tasks and App Contact related records
    public override void afterUpdate() {
        // Use checkStatus to only create tasks for Job Apps with changed Status
        List<Job_Application__c> appsWithNewStatus = JobApplicationUtils.checkStatus(newList, oldMap);
        if (!appsWithNewStatus.isEmpty()) {
            JobApplicationUtils.createTasks(appsWithNewStatus);
        }
        
        // Use checkForPrimaryChange to only create Application Contacts who have new Primary Contacts
        List<Job_Application__c> appsWithNewPrimary = checkForPrimaryChange(newList, oldMap);
        if (!appsWithNewPrimary.isEmpty()) {
            JobApplicationUtils.createAppContact(appsWithNewPrimary);
        }
    }
    
    // After Undelete  method sets the Primary Contact if it is null
    public override void afterUndelete() {
        JobApplicationUtils.setPrimaryContacts(newList);
    }


}