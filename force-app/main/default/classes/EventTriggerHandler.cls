public with sharing class EventTriggerHandler extends TriggerHandler {
    private List<Event> newList;
    
    public EventTriggerHandler() {
        this.newList = Trigger.new;
    }

    public override void beforeInsert() {
        EventUtils.eventOverlapValidate(newList);
    }

    public override void beforeUpdate() {
        EventUtils.eventOverlapValidate(newList);
    }
}