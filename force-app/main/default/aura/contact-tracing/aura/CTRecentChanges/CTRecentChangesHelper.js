({
    'fetchRecentHealthChanges': function (component) {
        let scope = component.get('v.scope');

        let actions = {
            'person': component.get('c.getRecentPersonHealthChanges'),
            'location': component.get('c.getRecentLocationHealthChanges')
        };

        let action = actions[scope];

        action.setCallback(this, (response) => {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let data = response.getReturnValue();

                component.set('v.data', data);
                component.set('v.initialResponse', data);
            }
        });

        $A.enqueueAction(action);
    },

    'searchRecords': function (component, searchTerm) {
        let scope = component.get('v.scope');

        let actions = {
            'person': component.get('c.searchPeople'),
            'location': component.get('c.searchLocations')
        };

        let action = actions[scope];

        action.setParams({
            'searchTerm': searchTerm
        });

        action.setCallback(this, (response) => {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let data = response.getReturnValue();

                if (data && data.length) {
                    component.set('v.data', data);
                }

                component.set('v.isSearching', false);
            }
        });

        $A.enqueueAction(action);
    }
});