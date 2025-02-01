/*
* 
* JobApplicationTest.cls contains test code for JobApplicationTrigger.trigger as well as the following classes:
*      - JobApplicationTriggerHandler.cls
*      - JobApplicationUtils.cls
* 
* - testSetPrimaryContact: Checks that if Primary_Contact__c is null and the record is updated or undeleted, if the
*      record has any Application Contacts, use the first one to set Primary__Contact__c
* 
* - testCreateTasks: Checks that the proper number of tasks have been created when reord is created or updated
* 
* - testCreateAppContact: If Primary_Contact__c is changed, make sure that a related contact record is created
*      without creating a duplicate
*  
*/
@isTest
public with sharing class JobApplicationTest {
    @isTest
    public static void testSetPrimaryContact() {
        // make 2 apps
        // add 2 contacts
        // set contact 1 as primary on app 1 and app 2
        // make app contact records for contact 2 with both apps
        // update app 1 to add a role or something
        // update app 2 to remove the primary contact (make null). and can do something else too but not needed
        // check that app 1 is still contact 1 and app 2 is now contact 2. Can do by making sure each contact has 1 job app or something

    }

    @isTest
    public static void testCreateTasks() {
        // Create 1 app with each status
        // ensure that each app has the correct number of tasks
        // update the status of 1 app
        // check for the correct number of tasks
        //could split into 2 methods, one each for create and update
    }

    @isTest
    public static void testCreateAppContact() {
        // make 1 contact and 2 job apps
        // make app contact record for contact and app 1
        // add contact to both job apps as primary
        // make sure that each job app has 1 app contact. That will make sure that the duplicate check is working and that app 1 does not have 2 records for contact
    }
}