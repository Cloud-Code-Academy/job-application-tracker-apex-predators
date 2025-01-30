/*
* 
* The EventTriggerHandler class executes the following actions:
* 
* - Before Insert:
*    - eventOverlapValidate: confirm that no new Events overlap with existing events
* 
* - Before Update:
*    - eventOverlapValidate: confirm that no new Events overlap with existing events
* 
*/
public with sharing class EventTriggerHandler extends TriggerHandler {
    // Create class variables
    private List<Event> newList;
    
    // Constructor sets the Trigger context variables to the correct SObject type    
    public EventTriggerHandler() {
        this.newList = Trigger.new;
    }

    /*
    * 
    * Before Save Methods
    * 
    */
    
    // Before Insert method ensures that new Events no not overlap with existing Events
    public override void beforeInsert() {
        EventUtils.eventOverlapValidate(newList);
    }

    // Before Update method ensures that new Events no not overlap with existing Events
    public override void beforeUpdate() {
        EventUtils.eventOverlapValidate(newList);
    }
}