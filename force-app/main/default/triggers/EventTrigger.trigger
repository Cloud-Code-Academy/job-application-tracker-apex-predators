trigger EventTrigger on Event (before insert, before update) {
    // Create an instance of the EventTriggerhandler and run it
    EventTriggerHandler eventTriggerInstance = new EventTriggerHandler();
    eventTriggerInstance.run();
}