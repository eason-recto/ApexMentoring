public with sharing class ERPCallout {

    
    public virtual class ERPCalloutException extends Exception {}
    public class EmptyParticipantException extends ERPCalloutException {}
    public class EmptyErpIdException extends ERPCalloutException {}

    public static final String REQUEST_METHOD_GET = 'GET';
    public static final String REQUEST_METHOD_POST = 'POST';
    private static final String REQUEST_ENDPOINT = 
    'https://66d67fcf006bfbe2e64d9591.mockapi.io/api/v1/participants/';    
    public static final String REQUEST_CONTENT_TYPE = 'Content-Type';
    public static final String REQUEST_CONTENT_TYPE_JSON = 'application/json';


    @InvocableMethod(
        label='Send Participant to ERP' 
        description='called from flow action button on Participant record page'
    )
    public static void sendParticipantToERP(List<ParticipantData> participantDataList) {

        ParticipantData participantData = participantDataList.get(0);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(REQUEST_ENDPOINT);
        request.setMethod(REQUEST_METHOD_POST);
        request.setHeader(REQUEST_CONTENT_TYPE, REQUEST_CONTENT_TYPE);
        
        String serializedBody = JSON.serialize(participantData);

        request.setBody(serializedBody);
        
        HttpResponse response = http.send(request);
        
        ERPPayload payload = (ERPPayload) JSON.deserialize(response.getBody(), ERPPayload.class);
        String erpId = payload.erpId;

        Participant__c participant = new Participant__c();
        participant.Id = participantData.Id;
        participant.ERP_Id__c = erpId;

        update participant;
        
    }
    /*
    public static void sendParticipantToERPFromBatch(List<Participant__c> participants) {

        List<Participant__c> participantsToUpdate = new List<Participant__c>();

        for (Participant__c participant : participants) {
            ParticipantData participantData = new ParticipantData();
            participantData.Id = participant.Id;
            participantData.Name = participant.Name;
            participantData.Status_ctemp = participant.Status__c;
    
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(REQUEST_ENDPOINT);
            request.setMethod(REQUEST_METHOD_POST);
            request.setHeader(REQUEST_CONTENT_TYPE, REQUEST_CONTENT_TYPE_JSON);
            
            String serializedBody = JSON.serialize(participantData).replace('_ctemp','__c');
            request.setBody(serializedBody);
            
            HttpResponse response = http.send(request);
            
            ERPPayload payload = (ERPPayload) JSON.deserialize(response.getBody(), ERPPayload.class);
            String erpId = payload.erpId;
    
            participant.ERP_Id__c = erpId;

            participantsToUpdate.add(participant);
        }

        update participantsToUpdate;
        
    }*/

    public static List<Participant__c> getParticipantsByErpId(String erpId) {
        List<Participant__c> participants = new List<Participant__c>();

        ParticipantData participantData = calloutGivenErpId(erpId);
        Participant__c queriedParticipant = queryParticipantById(participantData.Id);
        if (queriedParticipant == null) {
            throw new EmptyParticipantException('Participant with this ERP ID does not exist.');
        }

        Participant__c participant = new Participant__c();
        participant.Contact_Name__c = queriedParticipant.Contact_Name__c;
        participant.Training__c = queriedParticipant.Training__c;
        participant.Status__c = participantData.Status;

        participants.add(participant);
        
        insert participant;

        return participants;
    }

    private static ParticipantData calloutGivenErpId(String erpId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:EsMockApiParticipants' + '/' + erpId);
        // request.setHeader(REQUEST_CONTENT_TYPE, REQUEST_CONTENT_TYPE_JSON);
        request.setMethod(REQUEST_METHOD_GET);

        try {
            HttpResponse response = http.send(request);
            System.debug('response.getBody: ' + response.getBody());
            ParticipantData payload = (ParticipantData) JSON.deserialize(response.getBody(), ParticipantData.class);
            System.debug('payload: ' + payload);
            return payload;

        } catch(CalloutException e) {
            throw new CalloutException();
        }
    }

    private static Participant__c queryParticipantById(Id id) {
        return [
            SELECT Id, Contact_Name__c, Training__c
            FROM Participant__c
            WHERE Id = :id
            LIMIT 1
        ];
    }

    public class ERPPayload {
        public String erpId;
    }

    public class ParticipantData {
        @InvocableVariable(required=true)
        public String Email;

        @InvocableVariable(required=true)
        public Id Id;

        @InvocableVariable(required=true)
        public String Name;
        
        @InvocableVariable(required=true)
        public String Status;
    }
}