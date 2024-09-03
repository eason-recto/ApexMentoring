
public with sharing class UniversityDomainCheckerController {

    @AuraEnabled
    public static Boolean checkUniversityDomains(String domain) {
        if (domain == '') {
            return false;
        }

        String calloutBody = universityDomainCallout();
        return calloutBody.contains('\"' + domain + '\"');
    }

    private static String universityDomainCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:UniversityDomainAPI');
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            return response.getBody();
        } catch(CalloutException e) {
            throw new CalloutException();
        }
    }
}