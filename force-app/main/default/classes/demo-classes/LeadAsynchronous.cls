public with sharing class LeadAsynchronous {
    @Future
    public static void updateLeadRecords(Set<Id> existingRecordIds) {
        List<Lead> existingRecords = [
            SELECT Id, LeadSource
            FROM Lead
            WHERE Id IN :existingRecordIds
            WITH SECURITY_ENFORCED
        ];

        for (Lead record : existingRecords) {
            record.LeadSource = 'Web';
        }

        update as user existingRecords;
    }

    @Future
    public static void createLeadRecords() {
        Lead anotherLead = new Lead(LastName = 'Test Lead Single', Status = 'Open - Not Contacted', Company = 'sForce');
        insert as user anotherLead;
    }
}