public with sharing class CTLocationTriggerHandler {
    public static void beforeInsert(List<Location__c> newRecords) {
        for (Location__c location : newRecords) {
            location.Status__c = 'Green';
            location.Status_Update_Date__c = Date.today();
        }
    }

    public static void beforeUpdate(Map<Id, Location__c> oldMap, List<Location__c> newRecords) {
        for (Location__c location : newRecords) {
            String oldStatus = oldMap.get(location.Id).Status__c;
            String newStatus = location.Status__c;
            if (oldStatus != newStatus) {
                location.Status_Update_Date__c = Date.today();
            }
        }
    }

    public static void afterUpdate(Map<Id, Location__c> oldMap, List<Location__c> newRecords) {
        Set<Id> redStatus = new Set<Id>();

        for (Location__c location : newRecords) {
            String oldStatus = oldMap.get(location.Id).Status__c;
            String newStatus = location.Status__c;
            if (oldStatus != newStatus) {
                redStatus.add(location.Id);
            }
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationIds(redStatus);
        Set<Id> personIds = new Set<Id>();

        for (Location_Tracing__c trace : locationTraces) {
            personIds.add(trace.Person__c);
        }

        List<Person__c> peopleToUpdate = new List<Person__c>();
        for (Id pid : personIds) {
            peopleToUpdate.add(new Person__c(Id = pid, Health_Status__c = 'Yellow'));
        }

        if (peopleToUpdate.size() > 0) {
            update as user peopleToUpdate;
        }
    }
}
