public with sharing class PaymentLinkCallout {

    private static final String PAYMENT_LINK_ENDPOINT = 'https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link';

    public static void requestPaymentLink(List<Participant__c> participants) {
        String endpoint = PAYMENT_LINK_ENDPOINT;
        System.debug(endpoint);
        for (Participant__c participant : participants) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setHeader('content-type', 'application/json');
            request.setMethod('GET');

            Http http = new Http();

            HttpResponse response = http.send(request);
            PaymentPayload payload = PaymentPayload.parse(response.getBody());
            String link = payload.Payer.link;

            participant.PaymentLink__c = link;
        }
        
        update participants;
    }

    public static void sendPaymentEmail(Participant__c participant) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = createEmailToSendPaymentLink(participant);
        emails.add(mail);
        Messaging.sendEmail(emails);
    }

    private static Messaging.SingleEmailMessage createEmailToSendPaymentLink(Participant__c participant) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(participant.Contact_Name__c);
        mail.setWhatId(participant.Id);
        mail.setHTMLBody('Dear ' + participant.Contact_Name__r.Name + ',\n\n' +
                         'To complete your registration, please make a payment by clicking on the link below:\n\n' + 
                         participant.PaymentLink__c + '\n\n' +
                         'We are lookingforward to seeing you!\n\n' +
                         'Best regards,\n' + 
                         'Training Management System'
                        );
        return mail;
    }
}