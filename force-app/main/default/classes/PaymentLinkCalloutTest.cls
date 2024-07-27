@isTest
public with sharing class PaymentLinkCalloutTest {

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
        insert participant1;

        Participant__c participant2 = TestDataFactory.createNewParticipant(contact2, training);
        insert participant2;
    }

    @isTest 
    static void testRequestPaymentLink() {
        List<Participant__c> participants = [
            SELECT Id, PaymentLink__c, Training__r.Name, Contact_Name__c, Contact_Name__r.Name, Contact_Name__r.Email
            FROM Participant__c
        ];

        Test.setMock(HttpCalloutMock.class, new PaymentLinkCalloutMock());

        Test.startTest();
        PaymentLinkCallout.requestPaymentLink(participants);
        Test.stopTest();

        Assert.areEqual('https://pry.me/p/1688117280',
                        participants.get(0).PaymentLink__c,
                        'The participant\'s payment link should be populated.');
    }
}