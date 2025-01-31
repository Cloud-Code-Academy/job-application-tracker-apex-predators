
/**
 * Mock class to simulate a valid Jooble API response.
 * Includes multiple salary formats and an existing company.
 */
public with sharing class JoobleCalloutMockResponseValid implements HttpCalloutMock{
    
    /**
     * Responds to an HTTP request with a simulation.
     * @param request The incoming HTTP request.
     * @return A mock HttpResponse containing job listings.
     */
    public HttpResponse respond(HttpRequest request) {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);

        // Simulated job postings with various salary formats
        String responseBody = 
            '{' +
                '"jobs": [' +
                    '{' +
                        '"title": "Solution Architect",' +
                        '"location": "Miami, FL",' +
                        '"snippet": "Establish a sustainable technical architecture...",' +
                        '"salary": "$150K - $160K",' +
                        '"source": "snapjobsearch.com",' +
                        '"link": "https://jooble.org/desc/386733306",' +
                        '"company": "ABC Tech",' +
                        '"id": "12345"' +
                    '},' +
                    '{' +
                        '"title": "Salesforce Developer",' +
                        '"location": "Remote",' +
                        '"snippet": "Looking for an experienced Salesforce Developer...",' +
                        '"salary": "$24 - $28 per hour",' +
                        '"source": "snapjobsearch.com",' +
                        '"link": "https://jooble.org/desc/78362221",' +
                        '"company": "XYZ Solutions",' +
                        '"id": "67890"' +
                    '},' +
                    '{' +
                        '"title": "Business Analyst",' +
                        '"location": "New York, NY",' +
                        '"snippet": "Work with clients on technical solutions...",' +
                        '"salary": "$140k",' +
                        '"source": "jobfinder.com",' +
                        '"link": "https://jooble.org/desc/0987654321",' +
                        '"company": "XYZ Solutions",' +
                        '"id": "11223"' +
                    '}' +
                ']' +
            '}';
        response.setBody(responseBody);
        return response;
    }
}