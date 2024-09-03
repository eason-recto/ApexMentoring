public class HandleCustomException extends Exception {
    
    // Log Exception in CustomException object. 
    // relatedToId : Case/object for which this error in logged.
    public static void logException(Exception e, String relatedToId) {
        try {
		    String stackTrace = e.getStackTraceString().substringBefore('\n');
		    String className = stackTrace.substringAfter('.').substringBefore('.');	
            String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
            
            //Governer Limit of executingQuery 
            String queryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();   
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();
            
            //Log information in object
            Error_Log__c err = new Error_Log__c();
            err.Related_To__c= relatedToId;
            err.Governor_Limit__c = String.format('{0}\n{1}\n{2}\n{3}',new List<string>{QueryLimit, DMLimit,DMLStat,CPUT});
            err.Exception_Message__c = e.getMessage();
            err.Exception_Type__c = e.getTypeName();
            err.Line_Number__c = e.getLineNumber();
            err.Stack_Trace__c = e.getStackTraceString();
            err.Method_Name__c= methodName;
            err.Class_Name__c= className;
            err.Important__c= true;

            database.insert(err,false);      
            insert err;      
        } 
        
        finally {
        }            
    } 
}