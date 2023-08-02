trigger LeadTrigger on Lead (before insert, after insert, before update, after update) {
	switch on Trigger.operationType {
		when BEFORE_INSERT {
			LeadTriggerHandler.beforeInsert(Trigger.new);
		}
		
		when BEFORE_UPDATE {
			LeadTriggerHandler.beforeUpdate(Trigger.new , Trigger.oldMap);
		}
		
		when AFTER_INSERT {
			LeadTriggerHandler.afterInsert(Trigger.new);
		}
	}
}