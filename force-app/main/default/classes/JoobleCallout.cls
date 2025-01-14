public with sharing class JoobleCallout implements Queueable, Database.AllowsCallouts {
    // API endpoint, key, parameters
    private static final String JOOBLE_API_URL = 'https://jooble.org/api';
    private static final String JOOBLE_API_KEY = '09651830-e80f-4179-90f3-fe6f8dc909a3';
    
    // Class variables
    private String keywords; //keywords for job title search
    private String location; // location for job search
    private Integer days;    // how many days old a job posting can be to be searched

    // Class constructor
    public JoobleCallout (String keywords, String location, Integer days){
        this.keywords = keywords;
        this.location = location;
        this.days = days;
    }
    
    // Execute method for Queueable
    public void execute(QueueableContext context){        
        
        //Set up the HTTP request to send
        HttpRequest request = new HttpRequest();       
        request.setEndpoint(JOOBLE_API_URL + JOOBLE_API_KEY);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // Set body with generatePayload method
        request.setBody(generateJooblePayload(keywords, location, days));
        
        // Send the HTTP request and get the response
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Check Response
        if(response.getStatusCode() >= 200 && response.getStatusCode() <= 299){
            
        }
    }

    private static String generateJooblePayload(String keywords, String location, Integer days){

        // Calculate and format the date X days ago
        String formattedDate = Date.today().addDays(-days).format();
        // Build payload map
        Map<String,Object> jsonMap = new Map<String,Object>{
            'keywords' => keywords,
            'location' => location,
            'datecreatedfrom' => formattedDate
        };
        // Serialize and return the payload
        return JSON.serialize(jsonMap);        
    }
}