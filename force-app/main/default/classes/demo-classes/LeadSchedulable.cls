public with sharing class LeadSchedulable implements Schedulable {
	public void execute(SchedulableContext sc) {
		List<Lead> existingRecords = [SELECT Id, LeadSource FROM Lead WITH SECURITY_ENFORCED];

		for (Lead record : existingRecords) {
			record.LeadSource = 'Web';
		}

		update as user existingRecords;
	}
}