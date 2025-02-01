public with sharing class ApplicationContactUtils {
    public static void setPrimaryContacts (List<Application_Contact__c> appContacts){
        Map<Id, Application_Contact__c> appIdsByContact = new Map<Id, Application_Contact__c>();
        List<Job_Application__c> appsToUpdate = new List<Job_Application__c>();

        for (Application_Contact__c con : appContacts){
            appIdsByContact.put(con.Job_Application__c, con);
        }

        List<Job_Application__c> apps = [SELECT Id, Name FROM Job_Application__c WHERE Id IN :appIdsByContact.keySet()];

        for (Job_Application__c app : apps) {
            if (app.Primary_Contact__c == null){
                app.Primary_Contact__c = appIdsByContact.get(app.Id).Id;
                appsToUpdate.add(app);
            }
        }
        update appsToUpdate;
    }
}