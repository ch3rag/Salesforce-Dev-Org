public with sharing class LeadQueueable implements Queueable {
    public void execute(QueueableContext qc) {
        List<Lead> existingRecords = [SELECT Id, LeadSource FROM Lead WITH SECURITY_ENFORCED];

        for (Lead record : existingRecords) {
            record.LeadSource = 'Web';
        }

        update as user existingRecords;
    }
}
