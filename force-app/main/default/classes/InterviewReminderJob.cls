/**
 * InterviewReminderJob
 * Schedulable class to check for upcoming interviews, build email components for emailed reminders,
 *  then send those to the EmailService class to send the emails.
 */
public with sharing class InterviewReminderJob {

    /**
     * Executes the logic for sending interview reminders.
     * Queries interviews scheduled tomorrow.
     * Builds email reminder components and sends the components to create and send an email.
     */

    public static void runJob(){
        // Query Interviews for tomorrow
        List<Event> interviews = queryInterviews();
        // Process each returned interview if the Owner Email exists
        if(!interviews.isEmpty()){
            for(Event interview : interviews){
                if (interview.Owner.Email == null){
                    System.debug('No email found for owner of Event: ' + interview.Id);
                    continue;
                }
                buildEmailComponents(interview);                
            }
        }
    }

    /**
     * Queries interviews scheduled to occur tomorrow.
     * @return A list of events representing tomorrow's interviews.
     */
    private static List<Event> queryInterviews(){

        // Create Datetime variables to bound search
        Datetime tomorrowStart = Datetime.newInstance(Date.today().addDays(1), Time.newInstance(0, 0, 0, 0));
        Datetime tomorrowEnd = Datetime.newInstance(Date.today().addDays(1), Time.newInstance(23, 59, 59, 999));

        List<Event> interviews = [
            SELECT Subject, Owner.Email, Who.Name, StartDateTime,
                TYPEOF What
                    WHEN Job_Application__c THEN Position_Title__c, Company_Name__c
                END
            FROM Event
            WHERE StartDateTime >= :tomorrowStart AND StartDateTime <= :tomorrowEnd
        ];
        return interviews;
    }
    
    /**
     * Creates email components from an Event record.
     * Sends components to the EmailService class to send the email.
     * @param interview The event representing the interview. 
     */
    public static void buildEmailComponents(Event interview){

        String subject = 'Reminder: Upcoming Event';
        
        // Build email body
        String positionTitle = 'N/A';
        String companyName = 'N/A';
        // 
        if(interview.What != null && interview.What instanceof Job_Application__c){
            Job_Application__c job = (Job_Application__c)interview.What;
            positionTitle = job.Position_Title__c != null ? job.Position_Title__c : 'N/A';
            companyName = job.Company_Name__c != null ? job.Company_Name__c : 'N/A';
        }
        String formattedDateTime = interview.StartDateTime.format('MM/dd/yyy hh:mm a');
        String body =   'You have an interview scheduled tomorrow. \n\n' +
                        'Event Subject: ' + (interview.Subject != null ? interview.Subject : 'No Subject') + '\n' +
                        'Start Time: ' + formattedDateTime + '\n' +
                        'Contact Name: ' + (interview.Who != null ? interview.Who.Name : 'N/A') + '\n' +
                        'Position Title: ' + positionTitle + '\n' +
                        'Company: ' + companyName + '\n\n' +
                        'Best of luck!!';
        
        // Send the Email
        EmailService.sendEmail(subject, body, new List<String>{interview.Owner.Email});
    }
}