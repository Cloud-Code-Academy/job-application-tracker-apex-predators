/**
 * EventReminder
 * Utility class to build email components for event reminders, then send that to the EmailService class to send the email.
 */
public with sharing class EventReminder {
    
    public static void sendInterviewReminder(
        String ownerEmail,
        String eventSubject,
        String  contactName,
        String jobTitle,
        String companyName,
        Datetime interviewDateTime
    ) {

        String subject = 'Reminder: Upcoming Event';

        // Build subject body
        String formattedDateTime = interviewDateTime.format('MM/dd/yyy hh:mm a');
        String body =   'You have an interview scheduled tomorrow. \n\n' +
                        'Event Subject: ' + (eventSubject != null ? eventSubject : 'No Subject') + '\n' +
                        'Start Time: ' + formattedDateTime + '\n' +
                        'Contact Name: ' + (contactName != null ? contactName : 'N/A') + '\n' +
                        'Position Title: ' + (jobTitle != null ? jobTitle : 'N/A') + '\n' +
                        'Company: ' + (companyName != null ? companyName : 'N/A') + '\n\n' +
                        'Best of luck!!';
        
        // Send the Email
        EmailService.sendEmail(subject, body, new List<String>{ownerEmail});
    }
}