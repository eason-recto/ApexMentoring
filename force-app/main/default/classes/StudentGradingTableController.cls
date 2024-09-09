public with sharing class StudentGradingTableController {

    @AuraEnabled (cacheable=true)
    public static List<ParticipantWrapper> fetchParticipants(Id trainingId){
        List<Participant__c> participants = queryParticipants(trainingId);

        if (participants.isEmpty()) {
            return null;
        }
        
        return convertParticipantsToWrappers(participants);
    }

    @AuraEnabled
    public static List<ParticipantWrapper> getParticipants(Id trainingId){
        List<Participant__c> participants = queryParticipants(trainingId);

        if (participants.isEmpty()) {
            return null;
        }
        
        return convertParticipantsToWrappers(participants);
    }

    @AuraEnabled
    public static void updateParticipants(List<ParticipantWrapper> participantsToUpdate){
        System.debug(participantsToUpdate);
        if (participantsToUpdate.isEmpty()) {
            return;
        }
        
        List<Participant__c> participants = new List<Participant__c>();
        for (ParticipantWrapper participantWrapper : participantsToUpdate) {
            Participant__c participant = new Participant__c();
            participant.Id = participantWrapper.participantId;
            participant.Status__c = participantWrapper.participantStatus;
            participant.GPA__c = participantWrapper.participantGPA;
            participant.Passed__c = participantWrapper.participantPassed;

            participants.add(participant);
        }

        update participants;
    }

    @AuraEnabled
    public static ParticipantWrapper createParticipant(Participant__c participantToCreate){
        insert participantToCreate;

        List<Participant__c> queriedParticipant = [
            SELECT Id, Name, Status__c, GPA__c, Passed__c, Student_Name__c, Contact_Email__c
            FROM Participant__c
            WHERE Id = :participantToCreate.Id
        ];

        return convertParticipantsToWrappers(queriedParticipant).get(0);
        
    }

    @AuraEnabled
    public static ParticipantWrapper searchParticipants(String erpId){
    //public static ParticipantWrapper searchParticipants(Id trainingId, String erpId){
        if (String.isBlank(erpId)) {
            throw new NullPointerException();
        }

        List<Participant__c> participants = ERPCallout.getParticipantsByErpId(erpId);

        return convertParticipantsToWrappers(participants).get(0);

        /* List<Participant__c> participants = queryParticipantsByErpId(erpId); // NOT CORRECT

        if (participants.isEmpty()) {
            throw new ListException();
        }

        Participant__c queriedParticipant = participants.get(0);
        Participant__c newParticipant = new Participant__c();
        newParticipant.Contact_Name__c = queriedParticipant.Contact_Name__c;
        newParticipant.ERP_Id__c = queriedParticipant.ERP_Id__c;
        newParticipant.Status__c = 'Active';
        newParticipant.Training__c = queriedParticipant.Training__c;
        newParticipant.GPA__c = null;
        newParticipant.Passed__c = false;

        insert newParticipant; // CORRECT ?
        
        return convertParticipantsToWrappers(participants).get(0);*/
    }

    @AuraEnabled
    public static void deleteParticipant(ParticipantWrapper participant){
        Participant__c participantToDelete = queryParticipantById(participant.participantId);
        delete participantToDelete;
    }

    private static List<ParticipantWrapper> convertParticipantsToWrappers(List<Participant__c> participants) {
        List<ParticipantWrapper> participantWrappers = new List<ParticipantWrapper>();

        for (Participant__c participant : participants) {
            ParticipantWrapper participantWrapper = new ParticipantWrapper();
            participantWrapper.participantId = participant.Id;
            participantWrapper.participantURL = '/' + participant.Id;
            participantWrapper.participantName = participant.Student_Name__c;
            participantWrapper.participantEmail = participant.Contact_Email__c;
            participantWrapper.participantStatus = participant.Status__c;
            participantWrapper.participantGPA = participant.GPA__c;
            participantWrapper.participantPassed = participant.Passed__c;
            
            participantWrappers.add(ParticipantWrapper);            
        }

        return participantWrappers;
    }

    public static List<Participant__c> queryParticipants(Id trainingId) {
        return [
            SELECT Id, Name, Status__c, GPA__c, Passed__c, Student_Name__c, Contact_Email__c
            FROM Participant__c
            WHERE Training__c = :trainingId
            ORDER BY Name ASC
        ];
    }

    public static List<Participant__c> queryParticipantsByErpId(String erpId) {
        return [
            SELECT Id, Name, Status__c, GPA__c, Passed__c, Student_Name__c, Contact_Email__c, Contact_Name__c, ERP_Id__c, Training__c
            FROM Participant__c
            WHERE ERP_Id__c = :erpId
        ];
    }

    public static Participant__c queryParticipantById(Id participantId) {
        return [
            SELECT Id
            FROM Participant__c
            WHERE Id = :participantId
            LIMIT 1
        ];
    }

    public class ParticipantWrapper {
        @AuraEnabled
        public String participantName {get; set;}
        @AuraEnabled
        public String participantId {get; set;}
        @AuraEnabled
        public String participantURL {get; set;}
        @AuraEnabled
        public String participantEmail {get; set;}
        @AuraEnabled
        public String participantStatus {get; set;}
        @AuraEnabled
        public String participantGPA {get; set;}
        @AuraEnabled
        public Boolean participantPassed {get; set;}
    }
}