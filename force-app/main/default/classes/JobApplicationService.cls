/**
 * JobApplicationService
 *
 * This service class handles the processing and management of Job_Application__c records.
 * Responsibilities include:
 * - Creating new Account records based on company names pulled in from integration.
 * - Inserting Job_Application__c records into Salesforce.
 * 
 * This class is designed to work with data parsed from external job board integrations,
 * ensuring proper deduplication and efficient database operations.
 */

public with sharing class JobApplicationService {


    public static void processJobApplications(Set<String> companyNames, List<Job_Application__c> jobApplications) {

        //send accounts to be prepared and inserted
        Map<String,Id> accNameToIdMap = prepareAccounts(companyNames);

        //relate apps to accounts
        for(Job_Application__c app : jobApplications){
            app.Company__c = accNameToIdMap.get(app.Company_Name__c);
        }
        //insert apps
        try {
            insert jobApplications;
        } catch (DmlException e){
            System.debug('Error inserting job applications: ' + e.getMessage());
            sendErrorEmail('Job Application Insert Error', e.getMessage());
        }
    }

    public static Map<String, Id> prepareAccounts(Set<String> companyNames){

        List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name IN :companyNames];
        Map<String,Id> accNameToIdMap = new Map<String,Id>();
        for(Account acc : existingAccounts){
            if(companyNames.contains(acc.Name)){
                accNameToIdMap.put(acc.Name,acc.Id);
                companyNames.remove(acc.Name);
            }             
        }
        // If new companies exist, create and insert Account Records and update accNameToIdMap accordingly
        if (!companyNames.isEmpty()){
            processNewCompanies(companyNames, accNameToIdMap);
        }
        
        return accNameToIdMap;        
    }
    
    public static void processNewCompanies(Set<String> companyNames, Map<String,Id> accNameToIdMap){
        
        // Create Account Records for new companies 
        List<Account> accountsToCreate = new List<Account>();
        for(String company : companyNames){
            accountsToCreate.add(new Account(Name = company));
        }

        // Insert created Account Records
        try {
            insert accountsToCreate;
        } catch (DmlException e){
            System.debug('Error inserting Accounts: ' + e.getMessage());
            sendErrorEmail('Account Insert Error', e.getMessage());
        }
        // Add newly created Accounts to accNameToIdMap
        for(Account a : accountsToCreate){
            accNameToIdMap.put(a.Name, a.Id);
        }
    }

    public static void sendErrorEmail(String subject, String errorMessage){
        // Retrieve System Admin Email Addresses
        List<String> adminEmails = new List<String>();
        for(User user : [SELECT Email FROM User WHERE Profile.Name = 'System Administrator' AND isActive = true]){
            if(!String.isBlank(user.Email)){
                adminEmails.add(user.Email);
            }
        }
        // Send Email to System Admins. Output Error if unsuccessful 
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(adminEmails);
            mail.setSubject(subject);
            mail.setPlainTextBody('An error occurred: \n\n' + errorMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        } catch (Exception e){
            System.debug('Error sending email: ' + e.getMessage());
        }
    }
}