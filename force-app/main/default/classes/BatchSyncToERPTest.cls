@isTest
public with sharing class BatchSyncToERPTest {

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


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ERPCalloutMock());
        Id batchId = Database.executeBatch(new BatchSyncToERP(), 2000);
        Test.stopTest();

        AsyncApexJob job = [
            SELECT Id, Status
            FROM AsyncApexJob
            WHERE Id = :batchId
            LIMIT 1
        ];

        Assert.areEqual(
            job.Status,
            'Completed'
        );
    }
}