public with sharing class PaymentLinkCallout {
    public static void requestPaymentLink(List<Participant__c> participants) {
        String endpoint = 'https://735ef563-176d-431c-85ce-2cc07056ef03.mock.pstmn.io/payments/link';
        
        for (Participant__c participant : participants) {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setHeader('content-type', 'application/json');
            request.setMethod('GET');

            Http http = new Http();

            HttpResponse response = http.send(request);
            Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> payer = (Map<String, Object>) payload.get('payer');
            String link = (String) payer.get('link');

            participant.PaymentLink = link;
        }
        
        update participants;
    }

    public static void sendPaymentEmail(List<Participant__c> participants) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Participant__c participant : participants) {
            Messaging.SingleEmailMessage mail = createEmailToSendPaymentLink(participant);
            emails.add(mail);
        }
        Messaging.sendEmail(emails);
    }

    private Messaging.SingleEmailMessage createEmailToSendPaymentLink(Participant__c participant) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(participant.Contact_Name__c);
        mail.setWhatId(participant.Id);
        mail.setHTMLBody('Dear ' + participant.Contact_Name__r.Name + ',\n\n' +
                         'To complete your registration, please make a payment by clicking on the link below:\n\n' + 
                         participant.PaymentLink + '\n\n' +
                         'We are lookingforward to seeing you!\n\n' +
                         'Best regards,\n' + 
                         'Training Management System'
                        );
        return mail;
    }
}