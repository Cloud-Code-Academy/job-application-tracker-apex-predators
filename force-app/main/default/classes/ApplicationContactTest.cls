/*
* 
* ApplicationContactTest.cls contains test code for ApplicationContactTrigger.trigger as well as the following classes:
*      - ApplicationContactTriggerHandler.cls
*      - ApplicationContactUtils.cls
* 
* - setPrimaryContacts: Upon creation or update, if the related Job Application does not have a Primary_Contact__c,
*      use the related Contact to set the Job App's Primary_Contact__c
*  
*/
@isTest
public with sharing class ApplicationContactTest {
    @isTest
    public static void setPrimaryContacts() {
        // Make 3 Contacts: Contact 1 and Contact 2 or something
        // Make 2 Job Apps. Have Contact 1 as primary contact on App 1 and no primary on App 2
        // Make 2 App Contact records: Contact 2 for each Job App
        // Check that each Contact has exactly 1 Job App that it is primary on. That will ensure that 2 is populated and
        //      that 1 has not been overwritten
        // Clear out the primary contact on app 1 then update the role for its app contact with contact 2
        // check that now contact 1 has no job apps and contact 2 has 2
    }
}