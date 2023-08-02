public with sharing class AccountContactService {
	public static void updateActiveContacts(Set<Id> accountIds) {
		List<AggregateResult> results = [SELECT AccountId, COUNT(Id) totalContacts
										 FROM Contact
										 WHERE AccountId IN :accountIds AND Active__c = TRUE
										 GROUP BY AccountId];
		List<Account> accounts = new List<Account>();

		for (AggregateResult result : results) {
			String accountId = String.valueOf(result.get('AccountId'));
			Integer totalContacts = Integer.valueOf(result.get('totalContacts'));
			accounts.add(new Account(Id = accountId, Active_Contacts__c = totalContacts));
			// Remove Updated AccountId
			accountIds.remove(accountId);
		}

		// Left AccountIds Will Have Active_Contacts__c = 0
		for (Id accountId : accountIds) {
			accounts.add(new Account(Id = accountId, Active_Contacts__c = 0));
		}
		update accounts;
	}
}