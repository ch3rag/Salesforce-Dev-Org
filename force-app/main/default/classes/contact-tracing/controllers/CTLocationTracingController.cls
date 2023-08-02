// CTLocationTracingController Class

public with sharing class CTLocationTracingController {
	// Returns A List Location Tracings Who Has Visited A Location
	public static List<Location_Tracing__c> getVisitors(String locationId) {
		List<Location_Tracing__c> tracings = [SELECT Id, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c
											  FROM Location_Tracing__c
											  WHERE Location__c = :locationId
											  ORDER BY Visit_Date__c DESC];
		return tracings;
	}

	// Returns A List Location Tracing Of All The Locations Visited By Set Of PersonIds
	public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds) {
		List<Location_Tracing__c> tracings = [SELECT Id, Person__c, Location__c
											  FROM Location_Tracing__c
											  WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10];
		return tracings;
	}

	// Returns A List Location Tracing Of All The Locations In LocationsIds
	public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
		List<Location_Tracing__c> tracings = [SELECT Id, Person__c, Location__c
											  FROM Location_Tracing__c
											  WHERE Location__c IN :locationIds AND Visit_Date__c = LAST_N_DAYS:10 AND Person__r.Health_Status__c = 'Green'];
		
											  
		return tracings;
	}

	// Returns List Of Duplicate Location Tracing Records
	public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces) {
		// List Of Duplicates
		List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

		// Set For Location Ids
		Set<Id> locationIds = new Set<Id>();
		// Set For Person Ids
		Set<Id> personIds = new Set<Id>();

		// Iterate Over Location Tracing Records
		for (Location_Tracing__c tracing : locationTraces) {
			// Get Unique PersonIds And LocationIds
			personIds.add(tracing.Person__c);
			locationIds.add(tracing.Location__c);
		}

		// Map Of Existing Records
		Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

		List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Location__c IN :locationIds AND Person__c IN :personIds];

		if (existingRecords != null && existingRecords.size() > 0) {
			for (Location_Tracing__c existingRecord : existingRecords) {
				if (!mapOfExistingRecords.containsKey(existingRecord.Location__c)) {
					mapOfExistingRecords.put(existingRecord.Location__c, new Set<Id>());
				}
				mapOfExistingRecords.get(existingRecord.Location__c).add(existingRecord.Person__c);
			}
		}

		// Check For Duplicates
		for (Location_Tracing__c tracing : locationTraces) {
			if (mapOfExistingRecords.containsKey(tracing.Location__c) &&
				mapOfExistingRecords.get(tracing.Location__c).contains(tracing.Person__c)) {
					duplicates.add(tracing);					
				}
		}
		return duplicates;
	}
}