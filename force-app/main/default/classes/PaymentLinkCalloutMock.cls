@isTest
global class PaymentLinkCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('https://pry.me/p/1688117280');
        response.setStatusCode(200);
        return response;
    }
}