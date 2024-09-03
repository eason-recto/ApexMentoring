public class BatchSyncToERP implements Database.Batchable<sObject>, Database.AllowsCallouts {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name, Status__c FROM Participant__c';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Participant__c> participants) {
        for(Participant__c participant : participants) {
            ERPCallout.sendParticipantToERP(participant);
        }
        try {
            ERPCallout.sendParticipantToERPFromBatch(participants);

        } catch (DMLException e) {
            HandleCustomException.LogException(e);

        } catch (Exception e) {
            HandleCustomException.LogException(e);

        } finally {
        }
    }

    public void finish(Database.BatchableContext bc) {}
}