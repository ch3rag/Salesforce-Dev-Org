trigger CTPersonTrigger on Person__c (before insert, before update, after update) {
	switch on Trigger.operationType {
		when BEFORE_INSERT {
			CTPersonTriggerHandler.beforeInsert(Trigger.new);
		}

		when BEFORE_UPDATE {
			CTPersonTriggerHandler.beforeUpdate(Trigger.oldMap, Trigger.new);
		}

		when AFTER_UPDATE {
			CTPersonTriggerHandler.afterUpdate(Trigger.oldMap, Trigger.new);
		}
	}
}
