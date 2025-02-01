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

    }

    @isTest
    public static void testCreateTasks() {

    }

    @isTest
    public static void testCreateAppContact() {

    }
}