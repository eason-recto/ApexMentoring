@RestResource(urlMapping='/StripeWebhook/*')
global with sharing class StripeWebhookHandler {

	@HttpPost
	global static void handleStripeEvent() {
		RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        String requestBody = request.requestBody.toString();
        System.debug('Received Stripe event ' + requestBody);

        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        String eventType = (String) payload.get('type');
        Map<String, Object> data = (Map<String, Object>) payload.get('data');
        Map<String, Object> theObject = (Map<String, Object>) data.get('object');

        handleInvoiceCreated(theObject);

        response.statusCode = 200;
	}

	// Handle the invoice.created webhook
	public static void handleInvoiceCreated(Map<String, Object> theObject) {
		Invoice__c invoice = new Invoice__c();
        invoice.Stripe_Id__c = (String) theObject.get('id');
        invoice.Name = 'Invoice - ' + theObject.get('id');
        invoice.Amount_Due__c = (Decimal) theObject.get('amount_due');
        invoice.Amount_Paid__c = (Decimal) theObject.get('amount_paid');
        invoice.Amount_Remaining__c = (Decimal) theObject.get('amount_remaining');
        invoice.Customer_Email__c = (String) theObject.get('customer_email');
        invoice.Customer_Name__c = (String) theObject.get('customer_name');
        
        upsert invoice Stripe_Id__c;
	}
	
}