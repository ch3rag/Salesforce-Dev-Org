public class OpportunityController {
	public static void updateProfile(List<Id> opportunityIds) {
		List<Opportunity> opportunities = [SELECT Id, Amount, Profile__c FROM Opportunity WHERE Id IN :opportunityIds];
		for (Opportunity opportunity : opportunities) {
			if (opportunity.Amount == null) {
				opportunity.Profile__c = '';
			} else if (opportunity.Amount < 10000) {
				opportunity.Profile__c = 'Low';
			} else if (opportunity.Amount > 50000) {
				opportunity.Profile__c = 'High';
			} else {
				opportunity.Profile__c = 'Medium';
			}
		}
		update opportunities;
	}
}