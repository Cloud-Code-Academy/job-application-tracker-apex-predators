/*
* 
* EventTest.cls contains test code for EventTrigger.trigger as well as the following classes:
*      - EventTriggerHandler.cls
*      - EventUtils.cls
* 
* - testEventOverlapValidate: Checks that new Events do not overlap with existing Events
*  
*/
@isTest
public with sharing class EventTest {
    @isTest
    public static void testEventOverlapValidate() {
        // Make 1 event that will be pre-existing. Use today + 12 months and choose a time like 2-4
        // Make an event that starts during that event. Maybe 3-5. Make sure it errors
        // Make an event that ends during that event. Maybe 1-3. Make sure it errors
        // Make an event that encompasses that event. Maybe 1-5. Make sure it errors
        // Make an event that does not overlap with that event. Maybe 5-6. Make sure it does not error
        // Maybe then try updating that one that was 5-6 to be 3-5. Make sure it errors.
        // Could split that last one into a second method for update and keep rest for insert
    }
}