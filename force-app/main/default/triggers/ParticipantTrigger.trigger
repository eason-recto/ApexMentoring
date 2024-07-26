trigger ParticipantTrigger on Participant__c (before insert, after insert) {
	if(Trigger.IsBefore && Trigger.IsInsert) {
		ParticipantTriggerHandler.beforeInsert(Trigger.New);
    }
    
    if(Trigger.IsAfter && Trigger.IsInsert) {
		ParticipantTriggerHandler.afterInsert(Trigger.New, Trigger.oldMap);
    }
}