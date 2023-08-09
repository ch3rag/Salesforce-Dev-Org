public with sharing class CTLocationTabController {
	@AuraEnabled
	public static LocationInformation getLocationDetails(String recordId) {

		LocationInformation locationInfo = new LocationInformation();

		Location__c location = CTLocationController.getLocationById(recordId);

		if (location != null) {
			locationInfo.name = location.Name;
			locationInfo.redScore = Integer.valueOf(location.Red_Score__c);
			locationInfo.statusUpdateOn = location.Status_Update_Date__c;
			locationInfo.pincode = location.Pincode__c;
			locationInfo.status = location.Status__c;
		}

		List<Location_Tracing__c> traces = CTLocationTracingController.getVisitors(recordId);

		if (traces != null && traces.size() > 0) {
			List<CloseContact> closeContacts = new List<CloseContact>();

			for (Location_Tracing__c trace : traces) {
				CloseContact cc = new CloseContact();
				cc.id = trace.Person__c;
				cc.status = trace.Person__r.Health_Status__c;
				cc.token = trace.Person__r.Token__c;
				cc.visitDate = trace.Visit_Date__c;
				closeContacts.add(cc);
			}

			locationInfo.contacts = closeContacts;
			locationInfo.contactsCount = closeContacts.size();
		}
		return locationInfo;
	}

	public class LocationInformation {
		@AuraEnabled public String name;
		@AuraEnabled public Integer redScore;
		@AuraEnabled public Date statusUpdateOn;
		@AuraEnabled public String pincode;
		@AuraEnabled public String status;
		@AuraEnabled public Integer contactsCount = 0;
		@AuraEnabled public List<CloseContact> contacts;
	}

	public class CloseContact {
		@AuraEnabled public String id;
		@AuraEnabled public String token;
		@AuraEnabled public Date visitDate;
		@AuraEnabled public String status;
	}
}