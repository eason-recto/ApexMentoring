@isTest
public with sharing class BatchErrorLogCleanUpTest {

    @isTest 
    static void testDeleteErrorLogsSuccess() {
        Error_Log__c errorLog1 = new Error_Log__c();
        Error_Log__c errorLog2 = new Error_Log__c();
        
        insert new List<Error_Log__c>{errorLog1, errorLog2};

        Test.startTest();
        Id batchId = Database.executeBatch(new BatchErrorLogCleanUp(), 200);
        Test.stopTest();

        AsyncApexJob job = [
            SELECT Id, Status
            FROM AsyncApexJob
            WHERE Id = :batchId
            LIMIT 1
        ];

        Assert.areEqual(
            job.Status,
            'Completed'
        );
    }

    @isTest 
    static void testDeleteErrorLogsDMLException() {


        Test.startTest();
        Id batchId = Database.executeBatch(new BatchErrorLogCleanUp(), 200);
        Test.stopTest();

        AsyncApexJob job = [
            SELECT Id, Status
            FROM AsyncApexJob
            WHERE Id = :batchId
            LIMIT 1
        ];

        Assert.areEqual(
            job.Status,
            'Completed'
        );
    }
}