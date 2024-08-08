@isTest
public with sharing class StripeWebhookHandlerTest {
    @isTest
    static void StripeWebhookHandlerTest() {
        Invoice__c invoice = new Invoice__c();
        
        String JSONMsg = '{"data": {"object": {"id": "in_1PkadIEj3cPimBAXZPwgBHSI","amount_due": 0,"amount_paid": 0,"amount_remaining": 0}},"customer_email": "easonrecto@gmail.com","customer_name": "Eason Recto","type": "invoice.created"}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/StripeWebhook/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        StripeWebhookHandler.handleStripeEvent();
        Test.StopTest();   
    }
}