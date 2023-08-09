({
    'userSearchHandler': function (component, event, helper) {
        helper.fetchUserInformation(component);
    },

    'doInit': function (component, event, helper) {
        let columns = [
            { 'label': 'Token', 'fieldName': 'token', 'type': 'text' },
            { 'label': 'Contact Status', 'fieldName': 'status', 'type': 'text' },
            { 'label': 'Contact Date', 'fieldName': 'contactDate', 'type': 'date' }
        ];

        component.set('v.columns', columns);
    }
});