@IsTest
public with sharing class ContactTriggerHandlerTest {
	@TestSetup
	public static void makeDate() {
		List<Account> testAccounts = new List<Account> {
			new Account(Name = 'Test Account - 1'),
			new Account(Name = 'Test Account - 2')
		};
		insert testAccounts;
		
		List<Contact> testContacts = new List<Contact> {
			new Contact(LastName = 'Test Contact - 1', AccountId = testAccounts[0].Id, Active__c = true),
			new Contact(LastName = 'Test Contact - 2', AccountId = testAccounts[0].Id),
			new Contact(LastName = 'Test Contact - 3', AccountId = testAccounts[0].Id),
			new Contact(LastName = 'Test Contact - 4', AccountId = testAccounts[0].Id),
			new Contact(LastName = 'Test Contact - 5', AccountId = testAccounts[1].Id),
			new Contact(LastName = 'Test Contact - 6', AccountId = testAccounts[1].Id)
		};
		insert testContacts;
	}


	@IsTest
	public static void afterInsertTest() {
		List<Account> accounts = [SELECT Id, Name, Active_Contacts__c FROM Account];
 
		System.assertEquals(2, accounts.size(), 'Account size must be 2.');
		
		for (Account account : accounts) {
			if (account.Name == 'Test Account - 1') {
				System.assertEquals(1, account.Active_Contacts__c, 'Test Account - 1 must have exactly 1 active contact.');
			}

			if (account.Name == 'Test Account - 2') {
				System.assertEquals(0, account.Active_Contacts__c, 'Test Account - 2 must have exactly 0 active contact.');
			}
		}

		List<Contact> contacts = [SELECT Id, Name FROM Contact];
		System.assertEquals(6, contacts.size(), 'Contact size must be 6.');
	}
}
