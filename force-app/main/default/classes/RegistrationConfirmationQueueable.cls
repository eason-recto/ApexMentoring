public with sharing class RegistrationConfirmationQueueable implements Queueable {
    
    private Set<Id> participantIds;
    
    public RegistrationConfirmationQueueable (Set<Id> participantIds) {
        this.participantIds = participantIds;
    } 
    
    /* #5 - Queueable Apex
     * This method is a part of the Participant registration process.
     * It is called from the "ParticipantService" Class.
     */
    public void execute(QueueableContext context) {
        List<Participant__c> participants = ParticipantSelectors.queryParticipantsByIds(participantIds);
        
        PaymentLinkCallout.requestPaymentLink(participants);

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Participant__c participant : participants) {
            Messaging.SingleEmailMessage mail = createEmailToConfirmRegistration(participant);
            emails.add(mail);
        }
        Messaging.sendEmail(emails);
    }
    
    private Messaging.SingleEmailMessage createEmailToConfirmRegistration(Participant__c participant) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(participant.Contact_Name__c);
        mail.setWhatId(participant.Id);
        mail.setHTMLBody('Dear ' + participant.Contact_Name__r.Name + ',\n\n' +
                         'This email is a confirmation that you are successfully registered for course ' + participant.Training__r.Name + '. We look forward to seeing you in the course!\n\n' + 
                         'Best regards,\n' + 
                         'Training Management System'
                        );
        return mail;
    }
}