public with sharing class ParticipantTriggerHandler {
    
    public static void beforeInsert(List<Participant__c> newList) {
        
        ParticipantService participantService = new ParticipantService();
        List<Training__c> trainings = participantService.collectTrainingsFromParticipants(newList);
        
        TrainingService trainingService = new TrainingService();
        trainingService.calculateRestaurantCommissionForecast(trainings);
    }
    
    public static void afterInsert(List<Participant__c> newList, Map<Id, Participant__c> oldMap) {
        ParticipantService participantService = new ParticipantService();
        participantService.sendRegistrationConfirmationEmailsToParticipants(newList);
    }
}