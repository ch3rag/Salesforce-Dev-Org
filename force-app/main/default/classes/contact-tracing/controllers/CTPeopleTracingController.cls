// CTPeopleTracingController Class

public with sharing class CTPeopleTracingController {
    // Returns A  List Of People Tracing Records Related To A PersonId
    public static List<People_Tracing__c> getTraces(String personId) {
        List<People_Tracing__c> tracings = [
            SELECT
                Id,
                Person_1__c,
                Person_2__c,
                Contact_Date__c,
                Contact_Type__c,
                Person_1__r.Token__c,
                Person_1__r.Health_Status__C,
                Person_2__r.Token__c,
                Person_2__r.Health_Status__C
            FROM People_Tracing__c
            WHERE (Person_1__c = :personId OR Person_2__c = :personId) AND Contact_Date__c = LAST_N_DAYS:30
            WITH SECURITY_ENFORCED
            ORDER BY Contact_Date__c DESC
        ];
        return tracings;
    }

    // Returns A List Containing Duplicate Records That Are Already Present In The Database
    @SuppressWarnings('PMD.CognitiveComplexity')
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newTracings) {
        // List To Store Duplicates
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();

        // Get Unique Person Ids
        Set<Id> personIds = new Set<Id>();

        // Get All Unique Ids From New Records
        for (People_Tracing__c trace : newTracings) {
            personIds.add(trace.Person_1__c);
            personIds.add(trace.Person_2__c);
        }

        // Query All Existing Records Containing These Unique Ids
        List<People_Tracing__c> existingRecords = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE Person_1__c IN :personIds AND Person_2__c IN :personIds
            WITH SECURITY_ENFORCED
        ];

        // Construct Of Map Of Ids
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        // If Such Records Are Found
        if (existingRecords != null && existingRecords.size() > 0) {
            // Populate Map
            for (People_Tracing__c record : existingRecords) {
                if (!mapOfExistingRecords.containsKey(record.Person_1__c)) {
                    mapOfExistingRecords.put(record.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecords.get(record.Person_1__c).add(record.Person_2__c);

                if (!mapOfExistingRecords.containsKey(record.Person_2__c)) {
                    mapOfExistingRecords.put(record.Person_2__c, new Set<Id>());
                }
                mapOfExistingRecords.get(record.Person_2__c).add(record.Person_1__c);
            }
        }

        for (People_Tracing__c trace : newTracings) {
            if (
                (mapOfExistingRecords.containsKey(trace.Person_1__c) &&
                mapOfExistingRecords.get(trace.Person_1__c).contains(trace.Person_2__c)) ||
                (mapOfExistingRecords.containsKey(trace.Person_2__c) &&
                mapOfExistingRecords.get(trace.Person_2__c).contains(trace.Person_1__c))
            ) {
                duplicates.add(trace);
            }
        }

        return duplicates;
    }
}
