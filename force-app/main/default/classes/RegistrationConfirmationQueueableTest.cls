@IsTest
public with sharing class RegistrationConfirmationQueueableTest {
    
    @testSetup static void setup() {
        Contact contact = TestDataFactory.createNewContact('Eason', 'Recto');
        insert contact;
        
        Restaurant__c restaurant = TestDataFactory.createNewRestaurant('Testaurant');
        insert restaurant;
        
        Training__c training = TestDataFactory.createNewTraining(contact, restaurant, Date.today().addDays(3));
        insert training;
    }
    
	@isTest 
    static void testRegistrationConfirmationQueueable() {      
        
        Contact testContact = [
            SELECT Id
            FROM Contact
            LIMIT 1
        ];
        
        Training__c testTraining = [
            SELECT Id
            FROM Training__c
            LIMIT 1
        ];
        
        Participant__c testParticipant = new Participant__c();
        testParticipant.Status__c = 'Active';
        testParticipant.Training__c = testTraining.Id;
        testParticipant.Contact_Name__c = testContact.Id;

        Test.startTest();
        insert testParticipant;
        Test.stopTest();
        
        AsyncApexJob job = [
            SELECT Id, Status
            FROM AsyncApexJob
            LIMIT 1
        ];
        
        Assert.areEqual('Completed', job.Status);
    }
}