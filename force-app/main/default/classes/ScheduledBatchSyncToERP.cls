public with sharing class ScheduledBatchSyncToERP implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchSyncToERP(), 2000);
    }
}