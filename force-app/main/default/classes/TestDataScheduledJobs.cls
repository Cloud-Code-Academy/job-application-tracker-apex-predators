public with sharing class TestDataScheduledJobs {
    
    public static List<Event> generateData() {

        // Create test contact
        Contact cont = new Contact(
            FirstName = 'John',
            LastName = 'Doe'
        );
        insert cont;

        // Create test User
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Jane',
            LastName = 'Doe',
            Username = 'jane.doe@example.com.' + System.currentTimeMillis(),
            Email = 'jane.doe@example.com',
            Alias = 'jdoe',
            ProfileId = profile.Id,
            TimeZoneSidKey = 'America/New_York',  
            LocaleSidKey = 'en_US',             
            EmailEncodingKey = 'UTF-8',    
            LanguageLocaleKey = 'en_US' 
        );
        insert testUser;

        Job_Application__c testApp = new Job_Application__c(
            Position_Title__c = 'Salesforce Developer',
            Company_Name__c = 'Cloud Code Academy',
            Primary_Contact__c = cont.id,
            OwnerId = testUser.Id
        );
        insert testApp;

        // Create 3 Events, 2 negative and 1 positive to test query
        List<Event> eventList = new List<Event>();
        for(Integer i = 0; i < 3; i++){
            Event newEvent = new Event(
                Subject = 'Technical Interview ' + i,
                WhoId = cont.Id,
                WhatId = testApp.Id,
                StartDateTime = datetime.now().addDays(i),
                OwnerId = testUser.Id
            );
            newEvent.EndDateTime = newEvent.StartDateTime.addHours(2);
            eventList.add(newEvent);
        }
        insert eventList;
        return eventList;

    }

    /**
     * Generate additional data to more thoroughly test EmailService functionality
     * - Add a valid event where Owner has no email to test handling that gracefully
     * - Add Multiple valid events to test Bulk Email Sending
     */

     public static List<Event> generateMoreData(){

        // Pull in standard data
        List<Event> baseEvents = generateData();
        // Retrieve test Contact & Job Application
        Id contactId = baseEvents[0].WhoId;
        Id jobAppId = baseEvents[0].WhatId;
        Id ownerId = baseEvents[0].OwnerId; // has valid email

        // Event Owner with no Email
        Profile ownerProfile = [Select Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User secondEmailUser = new User(
            FirstName = 'anotherEmail',
            LastName = 'User',
            UserName = 'badEmail@example.com.' + System.currentTimeMillis(),
            Email = 'email@example.com',
            Alias = 'auser',
            ProfileId = ownerProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert secondEmailUser;

        List<Event> newEvents = new List<Event>();

        Event secondEmailEvent = new Event(
            Subject = 'Secondary User Email',
            WhoId = contactId,
            WhatId = jobAppId,
            OwnerId = secondEmailUser.Id,
            StartDateTime = DateTime.now().addDays(1)
            );
        secondEmailEvent.EndDateTime = secondEmailEvent.StartDateTime.addHours(1);
        newEvents.add(secondEmailEvent);

        // Valid Events for Bulk Testing
        for(Integer i = 0; i < 25; i++){
            Event bulkEvent = new Event(
                Subject = 'Bulk Event ' + i,
                WhoId = contactId,
                WhatId = jobAppId,
                ownerId = ownerId,
                StartDateTime = DateTime.now().addDays(1)
            );
        bulkEvent.EndDateTime = bulkEvent.StartDateTime.addHours(1);
        newEvents.add(bulkEvent);
        }
        insert newEvents;
        newEvents.addAll(baseEvents);
        return newEvents;
    }
}