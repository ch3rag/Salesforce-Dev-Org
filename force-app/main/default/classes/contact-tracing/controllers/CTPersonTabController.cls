public with sharing class CTPersonTabController {
	@AuraEnabled
	public static UserInformation getPersonDetails(String recordId) {

		UserInformation userInfo = new UserInformation();

		Person__c person = CTPersonController.getPersonById(recordId);

		if (person != null) {
			userInfo.name = person.Name;
			userInfo.token = person.Token__c;
			userInfo.statusUpdateOn = person.Status_Update_Date__c;
			userInfo.phone = person.Mobile__c;
			userInfo.status = person.Health_Status__c;
		}

		List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(recordId);

		if (traces != null && traces.size() > 0) {
			List<CloseContact> closeContacts = new List<CloseContact>();
			Set<Id> uniqueIds = new Set<Id>();
			uniqueIds.add(recordId);

			for (People_Tracing__c trace : traces) {
				CloseContact cc = new CloseContact();
				if (!uniqueIds.contains(trace.Person_1__c)) {
					cc.id = trace.Person_1__c;
					cc.status = trace.Person_1__r.Health_Status__c;
					cc.token = trace.Person_1__r.Token__c;
					cc.contactDate = trace.Contact_Date__c;
				}

				if (!uniqueIds.contains(trace.Person_2__c)) {
					cc.id = trace.Person_2__c;
					cc.status = trace.Person_2__r.Health_Status__c;
					cc.token = trace.Person_2__r.Token__c;
					cc.contactDate = trace.Contact_Date__c;
				}

				closeContacts.add(cc);
			}

			userInfo.contacts = closeContacts;
			userInfo.contactsCount = closeContacts.size();
		}
		return userInfo;
	}

	public class UserInformation {
		@AuraEnabled public String name;
		@AuraEnabled public String token;
		@AuraEnabled public Date statusUpdateOn;
		@AuraEnabled public String phone;
		@AuraEnabled public String status;
		@AuraEnabled public Integer contactsCount = 0;
		@AuraEnabled public List<CloseContact> contacts;
	}

	public class CloseContact {
		@AuraEnabled public String id;
		@AuraEnabled public String token;
		@AuraEnabled public Date contactDate;
		@AuraEnabled public String status;
	}
}