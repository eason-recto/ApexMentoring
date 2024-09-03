public class BatchErrorLogCleanUp implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public final static String MDT_STANDARD_DEVELOPER_NAME = 'Standard';

    public Database.QueryLocator start(Database.BatchableContext bc) {
        

        Error_Log_Setting__mdt errorLogSetting = [
            SELECT Days_Old__c
            FROM Error_Log_Setting__mdt
            WHERE DeveloperName = :MDT_STANDARD_DEVELOPER_NAME
            LIMIT 1
        ];

        Integer DAYS_OLD = (Integer) errorLogSetting.Days_Old__c;
        Date ERROR_LOG_DEADLINE = Date.today() - DAYS_OLD;
        String query = 'SELECT Id FROM Error_Log__c WHERE Important__c = false AND CreatedDate <= ' + ERROR_LOG_DEADLINE;

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Error_Log__c> errorLogs) {
        try {
            delete errorLogs;

        } catch (DMLException e) {
            HandleCustomException.LogException(e);

        } catch (Exception e) {
            HandleCustomException.LogException(e);

        } 
    }

    public void finish(Database.BatchableContext bc) {}
}