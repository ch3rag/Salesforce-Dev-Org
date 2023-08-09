trigger PersonTrigger on Person__c (before insert) {
	switch on Trigger.operationType {
		when BEFORE_INSERT {
			PersonTriggerHandler.beforeInsert(Trigger.new);
		}
	}
}