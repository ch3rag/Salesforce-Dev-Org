Map<Id, Lead> leadRecords = new Map<Id, Lead>([SELECT Id FROM Lead]);
LeadAsynchronous.updateLeadRecords(leadRecords.keySet());

