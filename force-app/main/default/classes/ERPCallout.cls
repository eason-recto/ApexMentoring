public with sharing class ERPCallout {

    
    public virtual class ERPCalloutException extends Exception {}
    public class EmptyParticipantException extends ERPCalloutException {}
    public class EmptyErpIdException extends ERPCalloutException {}

    public static final String REQUEST_METHOD_GET = 'GET';
    public static final String REQUEST_METHOD_POST = 'POST';
    private static final String REQUEST_ENDPOINT = 
    'https://64aa815a0c6d844abede843a.mockapi.io/api/v1/participants/';    
    public static final String REQUEST_CONTENT_TYPE = 'Content-Type';
    public static final String REQUEST_CONTENT_TYPE_JSON = 'application/json';


    @InvocableMethod(label='Send Participant to ERP' description='called from flow action button on Participant record page')
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
        participant.Id = participantData.id;
        participant.ERP_Id__c = erpId;

        update participant;
        
    }

    public class ERPPayload {
        public String erpId;
    }

    public class ParticipantData {
        @InvocableVariable(required=true)
        public String Name;
        
        @InvocableVariable(required=true)
        public String Email;
        
        @InvocableVariable
        public String salesforceId;

        @InvocableVariable(required=true)
        public Id id;
        
        @InvocableVariable
        public String status;
    }
}