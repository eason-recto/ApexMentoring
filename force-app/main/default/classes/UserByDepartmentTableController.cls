
public with sharing class UserByDepartmentTableController {
    @AuraEnabled
    public static List<AggregateResult> getActiveDepartments() {
        return [
            SELECT Department, count(Id) 
            FROM User 
            WHERE isActive = true AND Department != '' AND Department != null
            GROUP BY Department
        ];
    }

    @AuraEnabled
    public static List<User> getActiveUsersByDepartment(String department){
        List<User> queriedUsers = queryActiveUsersByDepartment(department);

        if (queriedUsers.isEmpty()) {
            throw new QueryException();
        }
        
        return queriedUsers;
        // return convertParticipantsToWrappers(participantsList).get(0);
    }

    /*private static List<ParticipantWrapper> convertParticipantsToWrappers(List<Participant__c> participants) {
        List<ParticipantWrapper> participantWrappers = new List<ParticipantWrapper>();

        for (Participant__c participant : participants) {
            ParticipantWrapper participantWrapper = new ParticipantWrapper();
            participantWrapper.participantId = participant.Id;
            participantWrapper.participantURL = '/' + participant.Id;
            participantWrapper.participantName = participant.Student_Name__c;
            participantWrapper.participantEmail = participant.Contact_Email__c;
            participantWrapper.participantStatus = participant.Status__c;
            participantWrapper.participantGPA = participant.GPA__c;
            participantWrapper.participantPassed = participant.Passed__c;
            
            participantWrappers.add(ParticipantWrapper);            
        }

        return participantWrappers;
    }*/

    public static List<User> queryActiveUsersByDepartment(String department) {
        List<User> users = new List<User>();
        if (department == 'All Departments') {
            users = [
                SELECT Id, Name, Email, Department
                FROM User
                WHERE Department != ''
                AND isActive = true
            ];
        }
        else {
            users = [
                SELECT Id, Name, Email, Department
                FROM User
                WHERE Department = :department
                AND isActive = true
            ];
        }

        if (users.size()>0) {
            return users;
        }
        else {
            throw new QueryException();
        }
    }

    /*public class UserWrapper {
        @AuraEnabled
        public String participantName {get; set;}
        @AuraEnabled
        public String participantId {get; set;}
        @AuraEnabled
        public String participantURL {get; set;}
        @AuraEnabled
        public String participantEmail {get; set;}
        @AuraEnabled
        public String participantStatus {get; set;}
        @AuraEnabled
        public String participantGPA {get; set;}
        @AuraEnabled
        public Boolean participantPassed {get; set;}
    }*/
}