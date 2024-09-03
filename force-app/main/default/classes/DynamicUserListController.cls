public with sharing class DynamicUserListController {
    @AuraEnabled
    public static String queryActiveUsers(){
        List<UserData> activeUsers = new List<UserData>();
        try {
            List<User> queriedUsers = [SELECT FirstName, LastName, Email, Phone FROM User WHERE IsActive = TRUE AND UserType = 'Standard'];
            
            for (User user : queriedUsers) {
                UserData userData = new UserData();
                userData.FirstName = user.FirstName;
                userData.LastName = user.LastName;
                userData.Email = user.Email;
                userData.Phone = user.Phone;
                
                activeUsers.add(userData);            
            }
            
            return JSON.serialize(activeUsers);

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class UserData {
        public String FirstName;
        public String LastName;
        public String Email;
        public String Phone;
    }
}