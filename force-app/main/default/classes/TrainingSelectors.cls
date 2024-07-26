public with sharing class TrainingSelectors {
    public static List<Training__c> queryTrainingsByIds(Set<Id> trainingIds) {
        return [SELECT Id, Restaurant__c, Start_Date__c, End_Date__c, Status__c
                FROM Training__c 
                WHERE Id IN :trainingIds
               ];
    }
    
    public static List<Training__c> queryTrainingsStartingInThreeDays() {
        return [SELECT Id, Name, Start_Date__c, End_Date__c, Trainer_Contact__c, Training__c.Trainer_Contact__r.Name,
                (SELECT Id, Contact_Name__r.FirstName, Contact_Name__r.LastName, Training__r.Name, 
                 Training__r.Start_Date__c, Training__r.End_Date__c
                 FROM Participants__r
                )
            	FROM Training__c
            	WHERE Start_Date__c = :Date.today().addDays(3)
        		];
    }
}