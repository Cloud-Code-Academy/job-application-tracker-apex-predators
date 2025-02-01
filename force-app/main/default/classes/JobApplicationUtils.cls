public with sharing class JobApplicationUtils {
    public static void setPrimaryContacts(List<Job_Application__c> apps) {
        List<Id> appIds = new List<Id>();
        Map<Id, Application_Contact__c> contactsForApps = new Map<Id, Application_Contact__c>();

        // Get the Id of every Job Application that needs a Primary Contact
        for (Job_Application__c app: apps) {
            if (app.Primary_Contact__c == null) {
                appIds.add(app.Id);
            }
        }

        // Get all Application Contacts for Job Applications that need a Primary Contact
        List<Application_Contact__c> contacts = [SELECT Id, Name FROM Application_Contact__c WHERE Job_Application__c IN :appIds];
        for (Application_Contact__c con : contacts) {
            // If no contact has been found yet for an application, record this one
            if (!contactsForApps.keySet().contains(con.Job_Application__c)) {
                contactsForApps.put(con.Job_Application__c, con);
            }
        }

        // Get the records that need a Primary Contact and retrieve contact from map
        List<Job_Application__c> appToUpdate = [SELECT Id, Name, Primary_Contact__c FROM Job_Application__c WHERE Id IN :appIds];
        for (Job_Application__c app : appToUpdate) {
            app.Primary_Contact__c = contactsForApps.get(app.Id).Id;
        }
    }

    public static List<Job_Application__c> checkStatus(List<Job_Application__c> newApps, Map<Id, Job_Application__c> oldApps) {
        List<Job_Application__c> appsWithNewStatus = new List<Job_Application__c>();

        for (Job_Application__c app : newApps){
            if (app.Status__c != oldApps.get(app.Id).Status__c) {
                appsWithNewStatus.add(app);
            }
        }
        return appsWithNewStatus;
    }

    public static void createTasks(List<Job_Application__c> apps) {
        List<Task> newTasks = new List<Task>();
        for (Job_Application__c app : apps) {
            if (app.Status__c == 'Saved'){
                newTasks.add(taskCreation(app, 5, 'Confirm Salary', 'Normal','Check the job posting or company website to confirm the Salary and update it on the job Application.'));
                newTasks.add(taskCreation(app, 5, 'Check Job Description For Fit', 'High','Check if the job description aligns with your interests and values.'));
                newTasks.add(taskCreation(app, 5, 'Review Highlighted Skills for Fit', 'Normal','Review the highlighted skills to see if the role is a good fit.'));
                newTasks.add(taskCreation(app, 5, 'Research Company/Role and Rate Job', 'Low','Research the company or role and mark your excitement level.'));

            } else if (app.Status__c == 'Applying'){
                newTasks.add(taskCreation(app, 5, 'Find Employee and Add as a Related Contact', 'Normal','Find and research someone who works at the company and add them as a contact.'));
                newTasks.add(taskCreation(app, 7, 'Set Up Informational Interview', 'Normal','Set up an informational interview to learn more about the role/company.'));
                newTasks.add(taskCreation(app, 5, 'Identify Potential Referrals', 'Low','Identify potential referrals to help get your application on the top of the pile.'));
                newTasks.add(taskCreation(app, 3, 'Customize Work Achievements', 'Normal','Customize your work achievements using the job description keywords.'));
                newTasks.add(taskCreation(app, 3, 'Submit Application', 'High','Submit your application, on the company website if possible.'));

            } else if (app.Status__c == 'Applied'){
                newTasks.add(taskCreation(app, 1, 'Make Contact', 'High','Reach out to the hiring manager or recruiter.'));
                newTasks.add(taskCreation(app, 7, 'Follow Up on Application', 'Normal','Follow up on your application via email weekly.'));
                newTasks.add(taskCreation(app, 1, 'Continue Applying', 'Low','Continue identifying and saving similar job opportunities.'));
                newTasks.add(taskCreation(app, 1, 'Set Up Weekly Networking Calls', 'Low','Set up weekly networking calls to explore similar companies/roles.'));

            } else if (app.Status__c == 'Interviewing'){
                newTasks.add(taskCreation(app, 1, 'Prepare Blurb', 'High','Prepare your blurb or “tell me about yourself” response.'));
                newTasks.add(taskCreation(app, 1, 'Practice Answering Questions', 'High','Practice answering behavioral interview questions.'));
                newTasks.add(taskCreation(app, 1, 'Research Company', 'High','Research the company and your interviewers.'));
                newTasks.add(taskCreation(app, 1, 'Set Up Space and Test Tech', 'High','Set up your virtual interview space and test your tech.'));
                newTasks.add(taskCreation(app, 1, 'Send Thank You Email', 'High','Send thank you emails within 24 hours.'));

            } else if (app.Status__c == 'Negotiating'){
                newTasks.add(taskCreation(app, 1, 'Research Market Value', 'Normal','Research your market value and know your numbers.'));
                newTasks.add(taskCreation(app, 1, 'Prepare Negotiation Script', 'Normal','Prepare your negotiation scripts.'));
                newTasks.add(taskCreation(app, 1, 'Evaluate Offer', 'High','Evaluate your offer and decline or accept.'));

            } else if (app.Status__c == 'Accepted'){
                newTasks.add(taskCreation(app, 1, 'Plan Resignation, if Applicable', 'Low','Plan your resignation if applicable.'));
                newTasks.add(taskCreation(app, 1, 'Relax and Recharge', 'High','Take some time to relax and recharge.'));
                newTasks.add(taskCreation(app, 1, 'Prepare for First Day', 'Normal','Prepare for your first day of onboarding.'));

            } else if (app.Status__c == 'Closed'){
                newTasks.add(taskCreation(app, 1, 'Send Follow-Up Email', 'High','Send a follow-up email thanking the interviewer and asking for feedback.'));
                newTasks.add(taskCreation(app, 1, 'Review and Reflect', 'Normal','Review your notes and reflect on areas of improvement.'));
            }
            insert newTasks;
        }
    }

    public static Task taskCreation (Job_Application__c app, Integer days, String taskSubject, String taskPriority, String taskDescription) {
        Task newTask = new Task();
        newTask.Subject = taskSubject;
        newTask.WhatId = app.Id;
        newTask.ActivityDate = Date.today().addDays(days);
        newTask.WhoId = app.Primary_Contact__c;
        newTask.OwnerId = UserInfo.getUserId();
        newTask.Status = 'Not Started';
        newTask.Priority = taskPriority;
        newTask.description = Taskdescription;

        return newTask;
    }

    public static void createAppContact (List<Job_Application__c> newApps, Map<Id, Job_Application__c> oldApps) {
        List<Application_Contact__c> accountContactsToCreate = new List<Application_Contact__c>();
        List<Application_Contact__c> existingAppContacts = [SELECT Id, Contact__c, Job_Application__c FROM Application_Contact__c WHERE Job_Application__c IN :newApps];

        for (Integer i=0; i<newApps.size(); i++) {
            if (newApps[i].Primary_Contact__c != oldApps.get(newApps[i].Id).Primary_Contact__c) {
                for (Application_Contact__c appCon : existingAppContacts) {
                    if (appCon.Job_Application__c == newApps[i].Id && appCon.Contact__c == newApps[i].Primary_Contact__c) {
                        newApps.remove(i);
                    }
                }
            }
        }

        if (!newApps.isEmpty()) {
            for (Job_Application__c jobApp : newApps) {
                Application_Contact__c newAppContact = new Application_Contact__c();
                newAppContact.Contact__c = jobApp.Primary_Contact__c;
                newAppContact.Job_Application__c = jobApp.Id;
                newAppContact.Role__c = 'Primary Contact';
                accountContactsToCreate.add(newAppContact);
            }
        }

        insert accountContactsToCreate;
    }
}