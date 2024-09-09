public with sharing class TopOpportunityTableController {
    @AuraEnabled
    public static List<OpportunityWrapper> getOpportunities(Integer opportunityLimit){

        if (opportunityLimit <= 0) {
            throw new IllegalArgumentException('You must choose to display 1 or more Opportunities.');
        }

        List<Opportunity> opportunities = queryOpportunities(opportunityLimit);

        if (opportunities.isEmpty()) {
            throw new ListException('No opportunities exist in the system.');
        }
        
        return convertOpportunitiesToWrappers(opportunities);
    }

    private static List<OpportunityWrapper> convertOpportunitiesToWrappers(List<Opportunity> opportunities) {
        List<OpportunityWrapper> opportunityWrappers = new List<OpportunityWrapper>();

        for (Opportunity opportunity : opportunities) {
            OpportunityWrapper opportunityWrapper = new OpportunityWrapper();
            opportunityWrapper.opportunityId = opportunity.Id;
            opportunityWrapper.opportunityURL = '/' + opportunity.Id;
            opportunityWrapper.opportunityName = opportunity.Name;
            opportunityWrapper.opportunityAmount = opportunity.Amount;
            opportunityWrapper.opportunityStageName = opportunity.StageName;
            opportunityWrapper.opportunityCloseDate = opportunity.CloseDate;
            opportunityWrapper.opportunityOwnerName = opportunity.Owner.Name;
            
            opportunityWrappers.add(opportunityWrapper);            
        }

        return opportunityWrappers;
    }

    public static List<Opportunity> queryOpportunities(Integer opportunityLimit) {
        return [
            SELECT Id, Name, Amount, CloseDate, StageName, Owner.Name
            FROM Opportunity
            ORDER BY Amount DESC
            LIMIT :opportunityLimit
        ];
    }

    public class OpportunityWrapper {
        @AuraEnabled
        public String opportunityName {get; set;}
        @AuraEnabled
        public String opportunityId {get; set;}
        @AuraEnabled
        public String opportunityURL {get; set;}
        @AuraEnabled
        public Decimal opportunityAmount {get; set;}
        @AuraEnabled
        public String opportunityStageName {get; set;}
        @AuraEnabled
        public Date opportunityCloseDate {get; set;}
        @AuraEnabled
        public String opportunityOwnerName {get; set;}
    }
}