public with sharing class AccountController {

	public static List<Account> insertAccounts(List<Account> accounts) {
		insert accounts;
		return accounts;
	}
	
	public static Account insertAccount(Account account) {
		insert account;
		return account;
	}
	
	public static List<Account> getAllAccounts() {
		List<Account> accounts = [SELECT Name, Phone FROM Account];
		return accounts;
	}
	
	public static void printAllAccounts() {
		List<Account> accounts = getAllAccounts();
		
		for (Account account : accounts) {
			System.debug('Account Name: ' + account.Name + ', Account Phone: ' + account.Phone);   
		}
	}
	
	public static Integer getAccountSize() {
		return getAllAccounts().size();
	}

	public static void updateAvgCaseResolutionDays(List<Id> accountIds) {
		
		// Get All Accounts And Associated Cases Using Parent Child Relationship Query
		List<Account> accounts = [SELECT Id, (SELECT CreatedDate, ClosedDate FROM Cases WHERE IsClosed = true) FROM Account WHERE Id IN :accountIds AND Id IN (SELECT AccountId FROM Case)];
		// For Each Account
		for (Account account : accounts) {
			Integer totalCases = 0;
			Integer totalDays = 0;
			// For All Cases In Each Account Calculate Total Cases And TotalDays
			for (Case caseObj : account.Cases) {
				totalCases++;
				totalDays += caseObj.CreatedDate.date().daysBetween(caseObj.ClosedDate.date());
			}
			// Find Average
			Decimal resolutionDays;
			if (totalCases > 0) {
				resolutionDays = totalDays / totalCases;
			}
			// Update Average Case Resolution Days Field Of The Account
			account.Avg_Case_Resolution_Days__c = resolutionDays;
		}
		// Commit The Changes In Database
		if (Account.getSObjectType().getDescribe().isUpdateable()) {
			update accounts;
		}
	}
}