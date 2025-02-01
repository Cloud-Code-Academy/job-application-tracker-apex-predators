public with sharing class JobApplicationTriggerHandler extends TriggerHandler{
    private List<Job_Application__c> newList;
    private Map<Id, Job_Application__c> oldMap;

    public JobApplicationTriggerHandler() {
        this.newList = (List<Job_Application__c>)Trigger.new;
        this.oldMap = (Map<Id,Job_Application__c>)Trigger.oldMap;
    }

    public override void beforeUpdate() {
        JobApplicationUtils.setPrimaryContacts(newList);
    }

    public override void afterInsert() {
        JobApplicationUtils.createTasks(newList);
        JobApplicationUtils.createAppContact(newList, oldMap);
    }

    public override void afterUpdate() {
        JobApplicationUtils.createTasks(JobApplicationUtils.checkStatus(newList, oldMap));
        JobApplicationUtils.createAppContact(newList, oldMap);
    }
    
    public override void afterUndelete() {
        JobApplicationUtils.setPrimaryContacts(newList);
    }


}