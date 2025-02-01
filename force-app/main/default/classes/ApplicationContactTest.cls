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
        
    }
}