public with sharing class TrainingTriggerHandler {
    
    public static void beforeInsert(List<Training__c> newList) {
        TrainingService service = new TrainingService();
        service.calculateRestaurantCommissionForecast(newList);
    }
    
    public static void afterInsert(List<Training__c> newList, Map<Id, Training__c> oldMap) {
        TrainingService service = new TrainingService();
        service.createTasksForTrainings(newList);
    }
    
    public static void beforeUpdate(List<Training__c> newList, Map<Id, Training__c> oldMap) {
        TrainingService service = new TrainingService();
        service.updateCompletionDateWhenTrainingIsCompleted(newlist, oldmap);
    }
    
    public static void afterUpdate(List<Training__c> newList, Map<Id, Training__c> oldMap) {
        TrainingService service = new TrainingService();
        service.updateParticipantStatusWhenTrainingIsCompleted(newlist, oldmap);
    }
}