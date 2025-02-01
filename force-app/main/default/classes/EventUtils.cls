public with sharing class EventUtils {
    public static void eventOverlapValidate(List<Event> newEvents) {
        Datetime rightNow = Datetime.now();
        List<Event> existingEvents = [SELECT Id, Subject, StartDateTime, EndDateTime FROM Event WHERE EndDateTime > :rightNow];
        Map<Datetime, Datetime> existingEventTimes = new Map<Datetime, Datetime>();

        for (Event e : existingEvents) {
            existingEventTimes.put(e.StartDateTime, e.EndDateTime);
        }
        for (Event newEvent : newEvents) {
            for (Datetime existingStart : existingEventTimes.keySet()) {
                if (newEvent.StartDateTime > existingStart && newEvent.StartDateTime < existingEventTimes.get(existingStart)) {
                    // Error saying that it starts during existing event
                    newEvent.addError('The event is set to start during an existing event.');

                } else if (newEvent.EndDateTime > existingStart && newEvent.EndDateTime < existingEventTimes.get(existingStart)) {
                    // Error saying that it ends during an existing event
                    newEvent.addError('The event is set to end during an existing event.');

                } else if (newEvent.StartDateTime < existingStart && newEvent.EndDateTime >existingEventTimes.get(existingStart)) {
                    // Error saying that it encompasses an existing event
                    newEvent.addError('The event is set to start before an existing event and end after it.');
                }
            }
        }
    }
}