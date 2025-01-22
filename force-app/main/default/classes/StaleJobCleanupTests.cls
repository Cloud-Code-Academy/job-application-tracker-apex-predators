@isTest
public with sharing class StaleJobCleanupTests {
    
    @isTest
    public void testStaleJobCleanupWithMultipleBatches() {

        // Create stale records to test process when completing multiple batch runs
        Integer staleRecords = 500;
        List<Job_Application__c> staleApps = new List<Job_Application__c>();
        for(Integer i = 0; i < totalStaleRecords; i++){
            Job_Application__c newStale = new Job_Application__c(
                Status__c = 'Saved'.
                Follow_up_Date__c = Date.today().addDays(-31)
            );
            staleApps.add(newStale);
        }

        insert staleApps;

        // Create fresh records for negative test
        Integer freshRecords = 25;
        List<Job_Application__c> freshApps = new List<Job_Application__c>();
        for(Integer i = 0; i < freshRecords; i++){
            Job_Application__c newFresh = new Job_Application__c(
                Status__c = 'Saved',
                Follow_up_Date__c = Date.today()
            );
        }



    }
}