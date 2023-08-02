trigger CTLocationTrigger on Location__c (before insert, before update, after update) {
	switch on Trigger.operationType {
		when BEFORE_UPDATE {
			CTLocationTriggerHandler.beforeUpdate(Trigger.oldMap, Trigger.new);
		}

		when BEFORE_INSERT {
			CTLocationTriggerHandler.beforeInsert(Trigger.new);
		}

		when AFTER_UPDATE {
			CTLocationTriggerHandler.afterUpdate(Trigger.oldMap, Trigger.new);
		}
	}
}