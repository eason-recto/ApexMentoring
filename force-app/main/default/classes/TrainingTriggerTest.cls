@isTest
private class TrainingTriggerTest {
    
    @isTest 
    static void testCalculateRestaurantCommissionForecast() {
        
        Restaurant__c testRestaurant = new Restaurant__c();
        testRestaurant.Name = 'Test Restaurant';
        testRestaurant.AverageMealCost__c = 10;
        testRestaurant.CommissionRate__c = 10;
        insert testRestaurant;
        
        Training__c testTraining = new Training__c();
        testTraining.Name = 'Test Training';
        testTraining.Start_Date__c = Date.today();
        testTraining.End_Date__c = Date.today()+10;
        testTraining.Restaurant__c = testRestaurant.Id;
        
        /*
        Participant__c testParticipant = new Participant();
        testParticipant.Status__c = 'Active';
        testParticipant.Training__c = testTraining.Id;
        testParticipant.Contact_Name__c = testContact.Id;
        insert testParticipant;
		*/
        
        Test.startTest();
        insert testTraining;
        Test.stopTest();
        
        testTraining = [SELECT Restaurant_Commission_Forecast__c FROM Training__c WHERE Id = :testTraining.Id];
        Assert.areEqual(9.00, testTraining.Restaurant_Commission_Forecast__c);
    }
    
    @isTest 
    static void testCreateTasksForTrainings() {
        
        Restaurant__c testRestaurant = new Restaurant__c();
        testRestaurant.Name = 'Test Restaurant';
        testRestaurant.AverageMealCost__c = 10;
        testRestaurant.CommissionRate__c = 10;
        insert testRestaurant;
        
        Training__c testTraining = new Training__c();
        testTraining.Name = 'Test Training';
        testTraining.Start_Date__c = Date.today();
        testTraining.End_Date__c = Date.today()+10;
        testTraining.Restaurant__c = testRestaurant.Id;
        
        Test.startTest();
        insert testTraining;
        Test.stopTest();
        
        List <Task> testTasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :testTraining.Id];
        Task testTask = testTasks.get(0);
        Assert.areEqual(testTraining.Id, testTask.WhatId);
    }
    
    @isTest 
    static void testUpdateCompletionDateWhenTrainingIsCompleted() {
        
        Restaurant__c testRestaurant = new Restaurant__c();
        testRestaurant.Name = 'Test Restaurant';
        testRestaurant.AverageMealCost__c = 10;
        testRestaurant.CommissionRate__c = 10;
        insert testRestaurant;
        
        Training__c testTraining = new Training__c();
        testTraining.Name = 'Test Training';
        testTraining.Start_Date__c = Date.today();
        testTraining.End_Date__c = Date.today()+10;
        testTraining.Restaurant__c = testRestaurant.Id;
        testTraining.Status__c = 'Scheduled';
        insert testTraining;
        
        testTraining.Status__c = 'Finished';
        
        Test.startTest();
        update testTraining;
        Test.stopTest();
        
        List<Training__c> testTrainings = [SELECT Id, Completion_Date__c FROM Training__c WHERE Id = :testTraining.Id];
        Training__c updatedTraining = testTrainings.get(0);
        Assert.areEqual(Date.today(), updatedTraining.Completion_Date__c);
    }
    
    @isTest 
    static void testUpdateParticipantStatusWhenTrainingIsCompleted() {
        
        Contact contact1 = new Contact();
        contact1.FirstName  = 'Joe';
        contact1.LastName  = 'Shmo';
        contact1.Email = 'contact1@test.com';
        
        insert contact1;
        
        Contact contact2 = new Contact();
        contact2.FirstName  = 'Bob';
        contact2.LastName  = 'Bee';
        contact2.Email = 'contact2@test.com';
        
        insert contact2;
        
        Restaurant__c testRestaurant = new Restaurant__c();
        testRestaurant.Name = 'Test Restaurant';
        testRestaurant.AverageMealCost__c = 10;
        testRestaurant.CommissionRate__c = 10;
        insert testRestaurant;
        
        Training__c testTraining = new Training__c();
        testTraining.Name = 'Test Training';
        testTraining.Start_Date__c = Date.today();
        testTraining.End_Date__c = Date.today()+10;
        testTraining.Restaurant__c = testRestaurant.Id;
        testTraining.Status__c = 'Scheduled';
        insert testTraining;
        
        Participant__c testParticipant1 = new Participant__c();
        testParticipant1.Status__c = 'Active';
        testParticipant1.Training__c = testTraining.Id;
        testParticipant1.Contact_Name__c = contact1.Id;
        insert testParticipant1;
        
        Participant__c testParticipant2 = new Participant__c();
        testParticipant2.Status__c = 'Active';
        testParticipant2.Training__c = testTraining.Id;
        testParticipant2.Contact_Name__c = contact2.Id;
        insert testParticipant2;
        
        testTraining.Status__c = 'Finished';
        
        Test.startTest();
        update testTraining;
        Test.stopTest();
        
        List<Participant__c> trainingParticipants = [SELECT Id, Status__c FROM Participant__c WHERE Training__c = :testTraining.Id];
        for (Participant__c participant : trainingParticipants) {
        	Assert.areEqual('Participated', participant.Status__c);
        }
    }
}