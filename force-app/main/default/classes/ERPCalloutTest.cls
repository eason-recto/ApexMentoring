@isTest
public with sharing class ERPCalloutTest {

    @testSetup 
    static void setup() {
        Contact contact1 = TestDataFactory.createNewContact('Eason', 'Recto');
        insert contact1;

        Contact contact2 = TestDataFactory.createNewContact('Eason', 'Recto');
        insert contact2;
        
        Restaurant__c restaurant = TestDataFactory.createNewRestaurant('Testaurant');
        insert restaurant;
        
        Training__c training = TestDataFactory.createNewTraining(contact1, restaurant, Date.today().addDays(3));
        insert training;
        
        Participant__c participant1 = TestDataFactory.createNewParticipant(contact1, training);
        Participant__c participant2 = TestDataFactory.createNewParticipant(contact2, training);
        
        insert new List<Participant__c>{participant1, participant2};
    }

    @isTest 
    static void testSendParticipantToERP() {

        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());

        List<ERPCallout.ParticipantData> participantDataList = new List<ERPCallout.ParticipantData>();

        ERPCallout.ParticipantData participantData = new ERPCallout.ParticipantData();
        participantData.Name = 'Rose Gonzalez';
        participantData.Email = 'rose@edge.com';
        participantData.salesforceId = '102';
        participantData.id = 'a01bm00000J21GPAAZ';
        participantData.status = 'Participated';
        participantDataList.add(participantData);

        Test.startTest();
        ERPCallout.sendParticipantToERP(participantDataList);
        Test.stopTest();

        Participant__c participant = [
            SELECT ERP_Id__c
            FROM Participant__c
            WHERE Id = :participantData.id
            ];

        Assert.isNotNull(
            participant.ERP_Id__c,
            'The participant\'s ERP Id should be populated.'
        );
    }
}