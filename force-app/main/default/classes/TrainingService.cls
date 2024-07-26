public with sharing class TrainingService {
    
    private static final string MDT_STANDARD_DEVELOPER_NAME = 'Standard';
    
    /* #1 - Triggers: Task #0 - Training Trigger (Solved in the class)
     * This method is a part of the Training creation process.
     * It is called from the "TrainingTriggerHandler" Class.
     * It returns a list of Tasks where one Task is created for each Training.
     * 
     * @param trainings - List of Trainings that cannot be null
     */
    public void createTasksForTrainings(List<Training__c> trainings) {
        
        List<Task> tasks = new List<Task>();
        for (Training__c training : trainings) {
            Task task = new Task();
            task.ActivityDate = date.today();
            task.Status = 'Not Started';
            task.Priority = 'Normal';
            task.Subject = 'Reminder ' + training.Name;
            task.Description = 'This task is just a reminder that a new course is about to start.';
            task.WhatId = training.Id;
            tasks.add(task);
        }
        
        insert tasks;
    }
    
    /* #1 - Triggers: Task #1 - Forecast Calculation
     * This method is a part of the Training restaurant commission calculation process.
     * It is called from the "TrainingTriggerHandler" Class.
     * 
     * @param trainings List of Trainings
     */
    public void calculateRestaurantCommissionForecast(List<Training__c> trainings) {
        
        List<Restaurant_Commission_Metadata__mdt> commissions = queryCommissionMetadataByDeveloperName(
            MDT_STANDARD_DEVELOPER_NAME
        );
        Restaurant_Commission_Metadata__mdt commission = commissions.get(0);

        Set<Id> restaurantIds = collectRestaurantIdsFromTrainings(trainings);
        
        List<Restaurant__c> restaurants = RestaurantSelectors.queryRestaurantsByIds(restaurantIds);
        Map<Id, Restaurant__c> restaurantIdsToRecords = new Map<Id, Restaurant__c>(restaurants);
        
        Decimal probabilityToBuyPerParticipant = commission.ProbabilitytoBuyPerParticipant__c/100.0;
                
        for (Training__c training : trainings) {
            Integer participantsNumber = training.Participants__r.isEmpty() ? 1 : training.Participants__r.size();
            Restaurant__c restaurant = restaurantIdsToRecords.get(training.Restaurant__c);
            training.Restaurant_Commission_Forecast__c = calculateCommission(training, restaurant, participantsNumber, probabilityToBuyPerParticipant);
        }
    }
    
    /* #1 - Triggers: Task #2 - Participated
     * This method is a part of the Training completion process.
     * It is called from the "TrainingTriggerHandler" Class.
     * 
     * @param trainings - List of Trainings that cannot be null
     * @param oldTrainings Map of Trainings with values prior to Trigger save - can be null and is not used
     */
    public void updateParticipantStatusWhenTrainingIsCompleted(List<Training__c> trainings, Map<Id, Training__c> oldTrainings) {
        List <Training__c> finishedTrainings = collectFinishedTrainings(trainings, oldTrainings);
        
        List<Participant__c> participants = new List<Participant__c>();
        for (Training__c training : finishedTrainings) {
            participants = ParticipantSelectors.queryParticipantsFromTrainings(finishedTrainings);
            
            for (Participant__c participant : participants) {
                participant.Status__c = 'Participated';
            }
        }
        
        update participants;
    }
    
    /* #1 - Triggers: Task #3 - Before Trigger for Completion Date
     * This method is a part of the Training completion process.
     * It is called from the "TrainingTriggerHandler" Class.
     * 
     * @param trainings - List of Trainings that cannot be null
     * @param oldTrainings Map of Trainings with values prior to Trigger save - can be null and is not used
     */
    public void updateCompletionDateWhenTrainingIsCompleted(List<Training__c> trainings, Map<Id, Training__c> oldTrainings) {
        List <Training__c> finishedTrainings = collectFinishedTrainings(trainings, oldTrainings);
        
        for (Training__c training : finishedTrainings) {
            training.Completion_Date__c = date.today();
        }
    }
    
    private List<Restaurant_Commission_Metadata__mdt> queryCommissionMetadataByDeveloperName(String developerName) {
        return [
            SELECT ProbabilitytoBuyPerParticipant__c
            FROM Restaurant_Commission_Metadata__mdt
            WHERE DeveloperName = :developerName
            LIMIT 1
        ];
    }
    
    private Set<Id> collectRestaurantIdsFromTrainings(List<Training__c> trainings) {
        Set<Id> restaurantIds = new Set<Id>();
        for(Training__c training : trainings) {
            restaurantIds.add(training.Restaurant__c);
        }
        return restaurantIds;
    }
    
    private Decimal calculateCommission(
        Training__c training,
        Restaurant__c restaurant,
        Integer participantsNumber,
        Decimal probabilityToBuyPerParticipant
    ) {
        Date startDate = training.Start_Date__c.date();
        Date endDate = training.End_Date__c.date();
        Integer trainingLengthInDays = startDate.daysBetween(endDate);
        Decimal averageMealCost = restaurant.AverageMealCost__c;
        Decimal commissionRate = restaurant.CommissionRate__c/100.0;
        
        return participantsNumber * trainingLengthInDays * commissionRate * probabilityToBuyPerParticipant * averageMealCost;
    }
    
    private List <Training__c> collectFinishedTrainings(List<Training__c> trainings, Map<Id, Training__c> oldTrainings) {
        List<Training__c> finishedTrainings = new List<Training__c>();
        for (Training__c training: trainings) {
            Training__c oldTraining = oldTrainings.get(training.Id);
            if (training.Status__c != oldTraining.Status__c && training.Status__c == 'Finished') {
                finishedTrainings.add(training);
            }
        }
        
        return finishedTrainings;
    }
}