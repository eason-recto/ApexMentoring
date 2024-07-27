public with sharing class ParticipantSelectors {
    public static List<Participant__c> queryParticipantsFromTrainings(List<Training__c> trainings) {
        return [
            SELECT Id
            FROM Participant__c
            WHERE Training__c IN :trainings
        ];
    }
    
    public static List<Participant__c> queryParticipantsByIds(Set<Id> participantIds) {
        return [
            SELECT Id, Training__r.Name, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Email
            FROM Participant__c 
            WHERE Id IN :participantIds
        ];
    }
}