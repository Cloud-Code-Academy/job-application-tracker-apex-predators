public with sharing class JoobleCallout implements Queueable, Database.AllowsCallouts {
    // API endpoint, key, parameters
    private static final String JOOBLE_API_URL = 'https://jooble.org/api/';
    private static final String JOOBLE_API_KEY = '09651830-e80f-4179-90f3-fe6f8dc909a3';
    
    // Class variables
    private Map<String, String> paramMap; //Map containing parameters
    private Integer days;    // how many days ago for a job created date

    // Class constructor
    public JoobleCallout (Map<String, String> paramMap, Integer days){
        this.paramMap = paramMap;
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
        request.setBody(generateJooblePayload(paramMap, days));
        
        // Send the HTTP request and get the response
        Http http = new Http();
        HttpResponse response = http.send(request);

        // Check Response
        if(response.getStatusCode() >= 200 && response.getStatusCode() <= 299){
            String jsonResponseBody = response.getBody();
            JobParser.parseJoobleApps(jsonResponseBody);
        }
    }

    private static String generateJooblePayload(Map<String, String> paramMap, Integer days){

        // Calculate and format the date X days ago
        String formattedDate = Date.today().addDays(-days).format();

        // Build payload map
        Map<String,Object> jsonMap = new Map<String,Object>();
        // Always include the datecreatedfrom parameter
        jsonMap.put('datecreatedfrom', formattedDate);
        for(String key : paramMap.keySet()){
            // Dynamically fill jsonMap from user defined settings
            jsonMap.put(key, paramMap.get(key));
        }
        // Serialize and return the payload
        system.debug(jsonMap);
        system.debug(JSON.serialize(jsonMap));
        return JSON.serialize(jsonMap);        
    }
}