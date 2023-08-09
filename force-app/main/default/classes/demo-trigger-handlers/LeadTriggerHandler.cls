public with sharing class LeadTriggerHandler {
    private static boolean alreadyExecuted = false;

    public static void beforeInsert(List<Lead> newRecords) {
        for (Lead leadRecord : newRecords) {
            if (String.isBlank(leadRecord.LeadSource)) {
                leadRecord.LeadSource = 'Other';
            }

            if (String.isBlank(leadRecord.Industry)) {
                leadRecord.addError('The industry field cannot be blank');
            }
        }
    }

    public static void beforeUpdate(List<Lead> newRecords, Map<Id, Lead> oldRecordsMap) {
        for (Lead leadRecord : newRecords) {
            if (String.isBlank(leadRecord.LeadSource)) {
                leadRecord.LeadSource = 'Other';
            }

            if (
                (leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted') &&
                oldRecordsMap.get(leadRecord.Id).Status == 'Open - Not Contacted'
            ) {
                leadRecord.Status.addError('You cannot directly close an open lead record.');
            }
        }
    }

    public static void afterInsert(List<Lead> newRecords) {
        List<Task> tasks = new List<Task>();

        for (Lead leadRecord : newRecords) {
            Task leadTask = new Task(Subject = 'Follow-up on Lead Status', WhoId = leadRecord.Id);
            tasks.add(leadTask);
        }

        insert as user tasks;
    }
}
