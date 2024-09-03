@RestResource(urlMapping='/StripeWebhook/*')
global without sharing class StripeWebhookHandler {

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

        if (eventType == 'invoice.created') {
            handleInvoiceCreated(data, theObject);
        }
        else if (eventType == 'invoice.updated') {
            handleInvoiceUpdated(data, theObject);
        }
        else if (eventType == 'invoice.paid') {
            handleInvoicePaid(theObject);
        }
        else if (eventType == 'invoice.voided') {
            handleInvoiceVoided(theObject);
        }
        else if (eventType == 'invoice.deleted') {
            handleInvoiceDeleted(theObject);
        }

        response.statusCode = 200;
	}

    public static void handleInvoiceCreated(Map<String, Object> data, Map<String, Object> theObject) {
		Invoice__c invoice = new Invoice__c();
        invoice.Stripe_Id__c = (String) theObject.get('id');
        invoice.Name = 'Invoice - ' + theObject.get('id');
        invoice.Amount_Due__c = (Decimal) theObject.get('amount_due') / 100.0;
        invoice.Amount_Paid__c = (Decimal) theObject.get('amount_paid') / 100.0;
        invoice.Amount_Remaining__c = (Decimal) theObject.get('amount_remaining') / 100.0;
        invoice.Customer_Email__c = (String) data.get('customer_email');
        invoice.Customer_Name__c = (String) data.get('customer_name');
        invoice.Stripe_Status__c = 'Created';
        
        upsert invoice Stripe_Id__c;
	}

    public static void handleInvoiceUpdated(Map<String, Object> data, Map<String, Object> theObject) {
		String stripeId = (String) theObject.get('id');
        Invoice__c invoice = [
            SELECT Id
            FROM Invoice__c
            WHERE Stripe_Id__c = :stripeId
            LIMIT 1
        ];
        invoice.Amount_Due__c = (Decimal) theObject.get('amount_due') / 100.0;
        invoice.Amount_Paid__c = (Decimal) theObject.get('amount_paid') / 100.0;
        invoice.Amount_Remaining__c = (Decimal) theObject.get('amount_remaining') / 100.0;
        invoice.Customer_Email__c = (String) data.get('customer_email');
        invoice.Customer_Name__c = (String) data.get('customer_name');
        invoice.Stripe_Status__c = 'Updated';
        
        update invoice;
	}

    public static void handleInvoicePaid(Map<String, Object> theObject) {
		String stripeId = (String) theObject.get('id');
        Invoice__c invoice = [
            SELECT Id
            FROM Invoice__c
            WHERE Stripe_Id__c = :stripeId
            LIMIT 1
        ];
        invoice.Amount_Due__c = (Decimal) theObject.get('amount_due') / 100.0;
        invoice.Amount_Paid__c = (Decimal) theObject.get('amount_paid') / 100.0;
        invoice.Amount_Remaining__c = (Decimal) theObject.get('amount_remaining') / 100.0;
        invoice.Stripe_Status__c = 'Paid';
        
        update invoice;
	}

    public static void handleInvoiceVoided(Map<String, Object> theObject) {
        String stripeId = (String) theObject.get('id');
        Invoice__c invoice = [
            SELECT Id
            FROM Invoice__c
            WHERE Stripe_Id__c = :stripeId
            LIMIT 1
        ];
        invoice.Stripe_Status__c = 'Voided';
        
        update invoice;
	}

    public static void handleInvoiceDeleted(Map<String, Object> theObject) {
        String stripeId = (String) theObject.get('id');
        Invoice__c invoice = [
            SELECT Id
            FROM Invoice__c
            WHERE Stripe_Id__c = :stripeId
            LIMIT 1
        ];
        
        delete invoice;
	}
	
}