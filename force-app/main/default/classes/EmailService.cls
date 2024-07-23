public with sharing class EmailService {
	/* #6 - Email Service
	 * This method is a part of the Participant registration process.
	 * It is called from the "ParticipantTriggerHandler" Class.
	 * 
	 * @param participants - List of Participants that cannot be null
	 */
    public static void sendEmailsToNotifyTrainers() {
        List<Training__c> trainings = TrainingSelectors.queryTrainingsStartingInThreeDays();
        
        List<Messaging.SingleEmailMessage> trainerEmails = new List<Messaging.SingleEmailMessage>();
        for (Training__c training : trainings) {
            Messaging.SingleEmailMessage trainerMail = createEmailToNotifyTrainer(training);
            trainerEmails.add(trainerMail);
        }
        Messaging.sendEmail(trainerEmails);
    }
    
    public static void sendEmailsToNotifyStudents() {
        List<Training__c> trainings = TrainingSelectors.queryTrainingsStartingInThreeDays();
        List<Messaging.SingleEmailMessage> studentEmails = new List<Messaging.SingleEmailMessage>();
        List<Participant__c> participants = new List<Participant__c>();
        for (Training__c training : trainings) {
            participants = training.Participants__r;
            for (Participant__c participant : participants) {
                Messaging.SingleEmailMessage studentMail = createEmailToNotifyStudent(participant);
            studentEmails.add(studentMail);
            }
        }
        Messaging.sendEmail(studentEmails);
    }
    
    private static Messaging.SingleEmailMessage createEmailToNotifyTrainer(Training__c training) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(training.Trainer_Contact__c);
        mail.setWhatId(training.Id);
        List<Participant__c> participants = new List<Participant__c>();
        participants = training.Participants__r;
        String participantBulletList = '';
        for (Participant__c participant : participants) {
            participantBulletList += '- ' + participant.Contact_Name__r.FirstName + ' ' + participant.Contact_Name__r.LastName + '\n';
        }
        mail.setHTMLBody('Dear ' + training.Trainer_Contact__r.Name + ',\n\n' +
                         'This is an automatic reminder for the upcoming training ' + training.Name + ' that will take place from ' + training.Start_Date__c + ' to ' + training.End_Date__c + '.\n\n' +
                         'There are in total ' + participants.size() + 'participants:\n\n' +
                         participantBulletList +
                         'Best regards,\n' + 
                         'Training Management System'
                        );
        return mail;
    }
    
    private static Messaging.SingleEmailMessage createEmailToNotifyStudent(Participant__c student) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(student.Contact_Name__c);
        mail.setWhatId(student.Id);
        mail.setHTMLBody('Dear ' + student.Contact_Name__r.firstName + ' ' + student.Contact_Name__r.lastName + ',\n\n' +
                         'This is an automatic reminder for the upcoming training ' + student.Training__r.Name + ' that will take place from ' + student.Training__r.Start_Date__c + ' to ' + student.Training__r.End_Date__c + '.\n\n' +
                         'Best regards,\n' + 
                         'Training Management System'
                        );
        return mail;
    }
}