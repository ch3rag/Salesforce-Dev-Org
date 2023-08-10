public with sharing class LeadBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead lead : scope) {
            lead.LeadSource = 'Web';
        }

        update as user scope;
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('LeadBatch Finished!');
    }
}
