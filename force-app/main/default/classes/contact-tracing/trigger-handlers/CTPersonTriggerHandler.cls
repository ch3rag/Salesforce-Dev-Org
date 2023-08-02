public with sharing class CTPersonTriggerHandler {
	public static void beforeInsert(List<Person__c> newRecords) {
		for (Person__c person : newRecords) {
			person.Health_Status__c = 'Green';
			person.Token__c = CTPersonController.getToken(person.Mobile__c);
			person.Status_Update_Date__c = Date.today();
		}
	}

	public static void beforeUpdate(Map<Id, Person__c> oldMap, List<Person__c> newRecords) {
		for (Person__c person : newRecords) {
			String oldHealthStatus = oldMap.get(person.Id).Health_Status__c;
			String newHealthStatus = person.Health_Status__c;
			if (newHealthStatus != oldHealthStatus) {
				person.Status_Update_Date__c = Date.today();
			}
		}
	}

	// Update Health Status Of Locations And Persons
	public static void afterUpdate(Map<Id, Person__c> oldMap, List<Person__c> newRecords) {
		// Set Of Person Ids Who's Health Status Has Been Changed To Red
		Set<Id> redStatusPersonIds = new Set<Id>();
		Set<Id> statusChange = new Set<Id>();
		
		for (Person__c person : newRecords) {
			String oldHealthStatus = oldMap.get(person.Id).Health_Status__c;
			String newHealthStatus = person.Health_Status__c;

			if (oldHealthStatus != newHealthStatus) {
				// For Location Updates
				statusChange.add(person.Id);
			}

			if (newHealthStatus == 'Red' && oldHealthStatus != 'Red') {
				// When Person's Health Status Changes To Red
				redStatusPersonIds.add(person.Id);
			}
		}

		Set<Id> alreadyProcessed = new Set<Id>();
		alreadyProcessed.addAll(redStatusPersonIds);
		
		// When A Person's Health Status Changes To Red
		// Primary Contacts And Co-Habitats Will Be Marked As 'Orange'
		// Secondary Contacts And Neighbours Will Be Marked As 'Yellow'
		
		// Set Of Person Ids Whose Statuses Will Be Changed To Orange
		Set<Id> updatePersonsToOrange = new Set<Id>();

		// Set Of Person Ids Whose Statuses Will Be Changed To Yellow
		Set<Id> updatePersonsToYellow = new Set<Id>();

		// Populate The Set Using Helpers In Controller Class
		updatePersonsToOrange.addAll(CTPersonController.getCohabitants(redStatusPersonIds, alreadyProcessed));
		Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatusPersonIds, alreadyProcessed);
		updatePersonsToOrange.addAll(primaryContacts);
		updatePersonsToYellow.addAll(CTPersonController.getNeighbours(redStatusPersonIds, alreadyProcessed));
		updatePersonsToYellow.addAll(CTPersonController.getSecondaryContacts(primaryContacts, alreadyProcessed));

		List<Person__c> peopleToUpdate = new List<Person__c>();

		for (Id pid : updatePersonsToOrange) {
			peopleToUpdate.add(new Person__c(Id = pid, Health_Status__c = 'Orange'));
		}

		for (Id pid : updatePersonsToYellow) {
			peopleToUpdate.add(new Person__c(Id = pid, Health_Status__c = 'Yellow'));
		}

		if (peopleToUpdate.size() > 0) {
			update peopleToUpdate;
		}

		List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
		if (locationTraces != null && locationTraces.size() > 0) {
			Set<Id> locationIds = new Set<Id>();
			for (Location_Tracing__c trace : locationTraces) {
				locationIds.add(trace.Location__c);
			}

			CTLocationController.updateRedScore(locationIds);
		}
	}
}
 