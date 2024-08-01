public with sharing class ERPCalloutMock implements HttpCalloutMock {
    public static final String PAYMENT_LINK = 'https://pry.me/p/1721958415';

    public HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader(ERPCallout.REQUEST_CONTENT_TYPE, ERPCallout.REQUEST_CONTENT_TYPE_JSON);
        response.setBody('{"createdAt":"2024-07-31T21:43:44.399Z","Email":"bond_john@grandhotels.com","erpId":"101","status":"Participated","salesforceId":"101","Name":"John Bond","id":"a01bm00000IhV6GAAV"}');
        response.setStatusCode(201);
        return response;
    }
}