
/**
 * Mock class to simulate a valid Jooble API response.
 * Includes multiple salary formats and an existing company.
 */
public with sharing class JoobleCalloutMockResponse implements HttpCalloutMock{
    
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
        
        // toggle between Simulated Valid and Invalid job postings with various salary formats
        if(request.getEndpoint().contains('valid')){
            response.setBody(getValidResponse());
        } else {
            response.setBody(getInvalidResponse());
        }
        return response;
    }
    
    /**
     * Returns a mock response body with valid job postings
     * @return a JSON string with properly formatted job listing data
     */
    public static String getValidResponse(){
        return '{' +
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
    }

    /**
     * Returns a mock response body with invalid job postings
     * @return a JSON string with improperly formatted job listing data
     */
    public static String getInvalidResponse(){
    
    return '{' +
                '"jobs": [' +
                    '{' +  // Missing company name
                        '"title": "Software Engineer",' +
                        '"location": "San Francisco, CA",' +
                        '"snippet": "Exciting role in a fast-growing company...",' +
                        '"salary": "$100K",' +
                        '"source": "jobfinder.com",' +
                        '"link": "https://jooble.org/desc/44556677",' +
                        '"company": "",' +  // Empty company
                        '"id": "ABC123"' +
                    '},' +
                    '{' +  // Invalid salary format
                        '"title": "Project Manager",' +
                        '"location": "Austin, TX",' +
                        '"snippet": "Looking for an experienced PM...",' +
                        '"salary": "Negotiable",' +  // Invalid salary format
                        '"source": "jobpost.com",' +
                        '"link": "https://jooble.org/desc/99887766",' +
                        '"company": "DEF Inc.",' +
                        '"id": "XYZ789"' +
                    '},' +
                    '{' +  // Missing job ID
                        '"title": "Marketing Specialist",' +
                        '"location": "Chicago, IL",' +
                        '"snippet": "Develop and execute marketing strategies...",' +
                        '"salary": "$60K - $70K",' +
                        '"source": "jobhub.com",' +
                        '"link": "https://jooble.org/desc/55667788",' +
                        '"company": "Marketing Pros",' +
                        '"id": null' +  // Missing ID
                    '}' +
                ']' +
            '}';
    }
}     