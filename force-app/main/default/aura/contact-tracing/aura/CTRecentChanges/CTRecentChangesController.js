({
    'doInit': function (component, event, helper) {
        let scope = component.get('v.scope');

        let columns = {
            'person': [
                { 'label': 'Name', 'fieldName': 'Name', 'type': 'text' },
                { 'label': 'Phone', 'fieldName': 'Mobile__c', 'type': 'text' },
                { 'label': 'Token', 'fieldName': 'Token__c', 'type': 'text' },
                { 'label': 'Health Status', 'fieldName': 'Health_Status__c', 'type': 'text' },
                { 'label': 'Status Update Date', 'fieldName': 'Status_Update__c', 'type': 'date' },
                {
                    'label': 'View',
                    'type': 'button',
                    'initialWidth': 135,
                    'typeAttributes': {
                        'label': 'View/Update',
                        'name': 'view_or_update',
                        'title': 'Click to View/Update'
                    }
                }
            ],
            'location': [
                { 'label': 'Name', 'fieldName': 'Name', 'type': 'text' },
                { 'label': 'Status', 'fieldName': 'Status__c', 'type': 'text' },
                { 'label': 'Red Score', 'fieldName': 'Red_Score__c', 'type': 'number' },
                { 'label': 'Pin Code', 'fieldName': 'Pincode__c', 'type': 'text' },
                { 'label': 'Address', 'fieldName': 'Address__c', 'type': 'text' },
                { 'label': 'Status Update Date', 'fieldName': 'Status_Update_Date__c', 'type': 'date' },
                {
                    'label': 'View',
                    'type': 'button',
                    'initialWidth': 135,
                    'typeAttributes': {
                        'label': 'View/Update',
                        'name': 'view_or_update',
                        'title': 'Click to View/Update'
                    }
                }
            ]
        };

        component.set('v.columns', columns[scope]);
        helper.fetchRecentHealthChanges(component);
    },

    'handleKeyUp': function (component, event, helper) {
        const ENTER_KEY_CODE = 13;

        let isEnterKey = event.keyCode === ENTER_KEY_CODE;

        let searchTerm = component.find('enter-search').get('v.value');

        if (!searchTerm) {
            component.set('v.data', component.get('v.initialResponse'));
        }

        if (isEnterKey) {
            component.set('v.isSearching', true);
            helper.searchRecords(component, searchTerm);
        }
    },

    'handleRowAction': function (component, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');
        let scope = component.get('v.scope');

        let applicationEvents = {
            'person': $A.get('e.c:CTPersonSelectApplicationEvent'),
            'location': $A.get('e.c:CTLocationSelectApplicationEvent')
        };
        let applicationEvent = applicationEvents[scope];

        if (action.name === 'view_or_update') {
            applicationEvent.setParams({
                'recordId': row.Id,
                'status': scope === 'person' ? row.Health_Status__c : row.Status__c
            });
            applicationEvent.fire();
        }
    }
});