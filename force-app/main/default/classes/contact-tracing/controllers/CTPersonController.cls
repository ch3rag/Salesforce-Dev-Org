// CTPersonController Class

public with sharing class CTPersonController {
    // Generate MD5 Hash From Person's Phone Number
    public static String getToken(String mobileNumber) {
        // Create A Blob
        Blob myBlob = Blob.valueOf(mobileNumber);
        Blob hash = Crypto.generateDigest('MD5', myBlob);
        return EncodingUtil.base64Encode(hash);
    }

    // Returns List Of First 100 Persons With Recent Health Change Updates
    public static List<Person__c> getRecentHealthChanges() {
        List<Person__c> persons = [
            SELECT Id, Name, Mobile__c, Health_Status__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WITH SECURITY_ENFORCED
            ORDER BY Status_Update_Date__c DESC NULLS LAST
            LIMIT 100
        ];
        return persons;
    }

    // Search Peoples Either By Name, Mobile Or Token
    public static List<Person__c> searchPeople(String searchTerm) {
        searchTerm += '%';
        List<Person__c> persons = [
            SELECT Id, Name, Mobile__c, Health_Status__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm
            WITH SECURITY_ENFORCED
            ORDER BY Status_Update_Date__c DESC NULLS LAST
        ];
        return persons;
    }

    // Search An Return Person By Person Id
    public static Person__c getPersonById(String personId) {
        List<Person__c> persons = [
            SELECT Id, Name, Mobile__c, Health_Status__c, Status_Update_Date__c, Token__c
            FROM Person__c
            WHERE Id = :personId
            WITH SECURITY_ENFORCED
        ];
        return (persons != null && persons.size() > 0) ? persons[0] : null;
    }

    // Returns A Map Of Health Status - Count Of Persons
    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> mapping = new Map<String, Integer>();

        AggregateResult[] results = [
            SELECT Health_Status__c, COUNT(Id) NumPeople
            FROM Person__c
            WITH SECURITY_ENFORCED
            GROUP BY Health_Status__c
        ];

        for (AggregateResult result : results) {
            String status = (String) result.get('Health_Status__c');
            Integer count = (Integer) result.get('NumPeople');
            mapping.put(status, count);
        }
        return mapping;
    }

    // Get All Cohabitants Of Person Ids Whose Health Status Is Either Green Or Yellow
    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed) {
        // Health Statuses Filter
        List<String> healthStatuses = new List<String>{ 'Green', 'Yellow' };
        // Query
        List<People_Tracing__c> cohabitants = [
            SELECT Person_2__c, Person_1__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :personIds
                OR Person_2__c IN :personIds)
                AND Contact_Type__c = 'Cohabitant'
                AND (Person_1__r.Health_Status__c IN :healthStatuses
                OR Person_1__r.Health_Status__c IN :healthStatuses)
            WITH SECURITY_ENFORCED
        ];
        Set<Id> cohabitantIds = new Set<Id>();
        // Make Sure That A Person In PersonIds Is Not A Co-Habitant Of Itself
        for (People_Tracing__c cohabitant : cohabitants) {
            if (!alreadyProcessed.contains(cohabitant.Person_1__c)) {
                cohabitantIds.add(cohabitant.Person_1__c);
                alreadyProcessed.add(cohabitant.Person_1__c);
            }

            if (!alreadyProcessed.contains(cohabitant.Person_2__c)) {
                cohabitantIds.add(cohabitant.Person_2__c);
                alreadyProcessed.add(cohabitant.Person_2__c);
            }
        }

        return cohabitantIds;
    }

    // Get All Neighbours Of Person Ids Whose Health Status Is Green
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed) {
        List<People_Tracing__c> neighbors = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                Contact_Type__c = 'Neighbour'
                AND (Person_1__c IN :personIds
                OR Person_2__c IN :personIds)
                AND (Person_1__r.Health_Status__c = 'Green'
                OR Person_2__r.Health_Status__c = 'Green')
            WITH SECURITY_ENFORCED
        ];

        Set<Id> neighbourIds = new Set<Id>();

        for (People_Tracing__c neighbor : neighbors) {
            if (!alreadyProcessed.contains(neighbor.Person_1__c)) {
                neighbourIds.add(neighbor.Person_1__c);
                alreadyProcessed.add(neighbor.Person_1__c);
            }

            if (!alreadyProcessed.contains(neighbor.Person_2__c)) {
                neighbourIds.add(neighbor.Person_2__c);
                alreadyProcessed.add(neighbor.Person_2__c);
            }
        }
        return neighbourIds;
    }

    // Get All Primary Contacts Of Person Ids Whose Health Status Is Either Green Or Yellow
    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> alreadyProcessed) {
        // Health Status Filter
        List<String> healthStatuses = new List<String>{ 'Green', 'Yellow' };
        // Query
        List<People_Tracing__c> primaryContacts = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :personIds
                OR Person_2__c IN :personIds)
                AND Contact_Type__c = 'Other'
                AND Contact_Date__c = LAST_N_DAYS:10
                AND (Person_1__r.Health_Status__c IN :healthStatuses
                OR Person_2__r.Health_Status__c IN :healthStatuses)
            WITH SECURITY_ENFORCED
        ];
        Set<Id> primaryContactIds = new Set<Id>();

        // Make Sure That A Person In PersonIds Is Not A Primary Contact Of Itself
        for (People_Tracing__c primaryContact : primaryContacts) {
            if (!alreadyProcessed.contains(primaryContact.Person_1__c)) {
                primaryContactIds.add(primaryContact.Person_1__c);
                alreadyProcessed.add(primaryContact.Person_1__c);
            }

            if (!alreadyProcessed.contains(primaryContact.Person_2__c)) {
                primaryContactIds.add(primaryContact.Person_2__c);
                alreadyProcessed.add(primaryContact.Person_2__c);
            }
        }
        return primaryContactIds;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> primaryContactIds, Set<Id> alreadyProcessed) {
        List<People_Tracing__c> secondaryContacts = [
            SELECT Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE
                (Person_1__c IN :primaryContactIds
                OR Person_2__c IN :primaryContactIds)
                AND Contact_Type__c = 'Other'
                AND Contact_Date__c = LAST_N_DAYS:10
                AND (Person_1__r.Health_Status__c = 'Green'
                OR Person_2__r.Health_Status__c = 'Green')
            WITH SECURITY_ENFORCED
        ];

        Set<Id> secondaryContactIds = new Set<Id>();

        for (People_Tracing__c secondaryContact : secondaryContacts) {
            if (!alreadyProcessed.contains(secondaryContact.Person_1__c)) {
                secondaryContactIds.add(secondaryContact.Person_1__c);
                alreadyProcessed.add(secondaryContact.Person_1__c);
            }

            if (!alreadyProcessed.contains(secondaryContact.Person_2__c)) {
                secondaryContactIds.add(secondaryContact.Person_2__c);
                alreadyProcessed.add(secondaryContact.Person_2__c);
            }
        }
        return secondaryContactIds;
    }
}
