public with sharing class ApplicationContactTriggerHandler extends TriggerHandler {
    private List<Application_Contact__c> newList;
    
    public ApplicationContactTriggerHandler() {
        this.newList = (List<Application_Contact__c>)Trigger.new;
    }
    // After a record is inserted, updated, or undeleted, check if the Job Application needs to have a Primary Contact.
    // If so, set the triggering record as the application's Primary Contact
    public override void afterInsert() {
        ApplicationContactUtils.setPrimaryContacts(newList);
    }

    public override void afterUpdate() {
        ApplicationContactUtils.setPrimaryContacts(newList);

    }

    public override void afterUndelete() {
        ApplicationContactUtils.setPrimaryContacts(newList);

    }
}