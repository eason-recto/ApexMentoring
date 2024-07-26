trigger TrainingTrigger on Training__c (before insert, after insert, before update, after update) {
    if(Trigger.IsBefore && Trigger.IsInsert) {
		TrainingTriggerHandler.beforeInsert(Trigger.New);
    }
    if(Trigger.IsAfter && Trigger.IsInsert) {
		TrainingTriggerHandler.afterInsert(Trigger.New, Trigger.oldMap);
    }
    if(Trigger.IsBefore && Trigger.IsUpdate) {
		TrainingTriggerHandler.beforeUpdate(Trigger.New, Trigger.oldMap);
    }
    if(Trigger.IsAfter && Trigger.IsUpdate) {
		TrainingTriggerHandler.afterUpdate(Trigger.New, Trigger.oldMap);
    }
}