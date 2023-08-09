public with sharing class ContactTriggerHandler {
    public static void afterInsert(List<Contact> newRecords) {
        Set<Id> accountIds = new Set<Id>();

        for (Contact contact : newRecords) {
            if (String.isNotBlank(contact.AccountId)) {
                accountIds.add(contact.AccountId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afterUpdate(Map<Id, Contact> oldMap, List<Contact> newRecords) {
        Set<Id> accountIds = new Set<Id>();

        for (Contact contact : newRecords) {
            String oldAccountId = oldMap.get(contact.Id).AccountId;
            String newAccountId = contact.AccountId;
            Boolean isActiveOld = oldMap.get(contact.Id).Active__c;
            Boolean isActiveNew = contact.Active__c;

            if (isActiveOld != isActiveNew || newAccountId != oldAccountId) {
                if (String.isNotBlank(contact.AccountId)) {
                    accountIds.add(newAccountId);
                }

                if (oldAccountId != newAccountId && String.isNotBlank(oldAccountId)) {
                    accountIds.add(oldAccountId);
                }
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afterDelete(List<Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();

        for (Contact contact : oldContacts) {
            if (String.isNotBlank(contact.AccountId)) {
                accountIds.add(contact.AccountId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afterUndelete(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();

        for (Contact contact : newContacts) {
            if (String.isNotBlank(contact.AccountId)) {
                accountIds.add(contact.AccountId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }
}
