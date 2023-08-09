// CTLocationController Class
public with sharing class CTLocationController {

	// Returns Recent Records Of Location With Recent Status Changes
	public static List<Location__c> getRecentStatusChanges() {
		List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c,Red_Score__c, Status__c, Status_Update_Date__c
									   FROM Location__c
									   ORDER BY Status_Update_Date__c DESC
									   NULLS LAST
									   LIMIT 100];
		return locations;
	}

	// Search Locations Using SearchTerm
	public static List<Location__c> searchLocations(string searchTerm) {
		searchTerm += '%';
		List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c
									   FROM Location__c
									   WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm
									   ORDER BY Status_Update_Date__c DESC
									   NULLS LAST];
		return locations;
	}

	// Search A Location By It's Id
	public static Location__c getLocationById(String locationId) {
		List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c
									   FROM Location__c
									   WHERE Id = :locationId];
		return (locations != null && locations.size() > 0)? locations[0] : null;
	}

	// Returns A Map Of Health Status - Count Of Locations
	public static Map<String, Integer> getStatusCount() {
		Map<String, Integer> mapping = new Map<String, Integer>();

		AggregateResult[] results = [SELECT Status__c, COUNT(Id) NumLocations FROM Location__c GROUP BY Status__c];
		
		for (AggregateResult result : results) {
			String status = (String)result.get('Status__c');
			Integer count = (Integer)result.get('NumLocations');
			mapping.put(status, count);
		}

		return mapping;
	}
	

	public static void updateRedScore(Set<Id> locationIds) {
		List<Location__c> locationsToUpdate = new List<Location__c>();

		AggregateResult[] redPeoplePerLocation = [SELECT Location__c, COUNT(Id) Total FROM Location_Tracing__c
												  WHERE Person__r.Health_Status__c = 'Red'
													AND Visit_Date__c = LAST_N_DAYS:10
													AND Location__c IN :locationIds
												  GROUP BY Location__c];
		for (AggregateResult ar : redPeoplePerLocation) {
			String locationId = String.valueOf(ar.get('Location__c'));
			Integer redScore = Integer.valueOf(ar.get('Total'));
			String status = getStatus(redScore);
			locationsToUpdate.add(new Location__c(Id = locationId, Red_Score__c = redScore, Status__c = status));
		}
		
		if (locationsToUpdate != null && locationsToUpdate.size() > 0) {
			update locationsToUpdate;
		}
	}

	public static String getStatus(Integer redScore) {
		if (redScore == 0) {
			return 'Green';
		} else if (redScore <= 5) {
			return 'Yellow';
		} else if (redScore <= 10) {
			return 'Orange';
		} else {
			return 'Red';
		}
	}
}