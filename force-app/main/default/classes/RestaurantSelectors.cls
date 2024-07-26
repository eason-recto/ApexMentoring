public with sharing class RestaurantSelectors {
    public static List<Restaurant__c> queryRestaurantsByIds(Set<Id> restaurantIds) {
        return [
            SELECT Id, AverageMealCost__c, CommissionRate__c 
            FROM Restaurant__c 
            WHERE Id IN :restaurantIds
        ];
    }
}