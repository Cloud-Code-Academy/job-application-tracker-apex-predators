trigger ApplicationContactTrigger on Application_Contact__c (after insert, after update, after undelete) {
    // Create an instance of the ApplicationContactTriggerHandler class and run it
    ApplicationContactTriggerHandler conAppTrigger = new ApplicationContactTriggerHandler();
    conAppTrigger.run();
}