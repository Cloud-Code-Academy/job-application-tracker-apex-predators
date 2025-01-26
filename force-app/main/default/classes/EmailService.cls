/**
 * EmailService
 * 
 * This service class provides a utility method to send emails in Salesforce. It is designed to handle 
 * various email-sending scenarios in a reusable and scalable way.
 */

public with sharing class EmailService {

    /**
     * Sends an email to the specified list of recipients.
     * 
     * This method constructs a single email message with a subject and body, then sends it to all 
     * recipients provided in the `emailAddresses` parameter. If the operation fails, an error message 
     * is logged to aid in debugging.
     * 
     * @param subject The subject line of the email.
     * @param body The body of the email. This is plain text by default.
     * @param emailAddresses A list of recipient email addresses. All recipients will receive the same email.
     */ 
    public static void sendEmail(String subject, String body, List<String> emailAddresses){
    
        // Send Email build from input parameters.  Output Error if unsuccessful 
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emailAddresses);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        } catch (Exception e){
            System.debug('EmailService.sendEmail: Error sending email - ' + e.getMessage());
        }
    }
}