@IsTest
public with sharing class TrainingReminderScheduledTest {
    
    @testSetup 
    static void setup() {
        Contact contact = TestDataFactory.createNewContact('Eason', 'Recto');
        insert contact;
        
        Restaurant__c restaurant = TestDataFactory.createNewRestaurant('Testaurant');
        insert restaurant;
        
        Training__c training = TestDataFactory.createNewTraining(contact, restaurant, Date.today().addDays(3));
        insert training;
        
        Participant__c participant = TestDataFactory.createNewParticipant(contact, training);
        insert participant;
    }
    
	@isTest 
    static void testTrainingReminderScheduled() {   
        
        String CRON_EXP = '0 0 9 1/1 * ? *';
        
        Test.startTest();
        String jobId = System.schedule('Scheduled_Training_Reminder_Test',
            CRON_EXP, 
            new TrainingReminderScheduled());
        Test.stopTest();
        
        AsyncApexJob job = [
            SELECT Id, Status
            FROM AsyncApexJob
            LIMIT 1
        ];
        
        Assert.areEqual('Completed', job.Status);
    }
}