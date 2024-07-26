public with sharing class ParticipantService {
    
    /* #2 - Triggers
	 * This method is a part of the Training restaurant commission calculation process.
	 * It is called from the "ParticipantTriggerHandler" Class.
	 * 
	 * @param participants - List of Participants that cannot be null
	 */
    public List<Training__c> collectTrainingsFromParticipants(List<Participant__c> participants) {
        
        Set<Id> trainingIds = collectTrainingIdsFromParticipants(participants);
        
        List<Training__c> trainings = TrainingSelectors.queryTrainingsByIds(trainingIds);
        
        return trainings;
    }
    
    /* #5 - Queueable Apex
	 * This method is a part of the Participant registration process.
	 * It is called from the "ParticipantTriggerHandler" Class.
	 * 
	 * @param participants - List of Participants that cannot be null
	 */
    public void sendRegistrationConfirmationEmailsToParticipants(List<Participant__c> participants) {
        Set<Id> participantIds = (new Map<Id, Participant__c> (participants)).keySet();
        System.enqueueJob(new RegistrationConfirmationQueueable(participantIds));
    }
    
    private Set<Id> collectTrainingIdsFromParticipants(List<Participant__c> participants) {
        Set<Id> trainingIds = new Set<Id>();
        for(Participant__c participant : participants) {
            trainingIds.add(participant.Training__c);
        }
        return trainingIds;
    }
}