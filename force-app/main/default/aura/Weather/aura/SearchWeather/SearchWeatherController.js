({
    'weatherSearchHandler': function (component, event, helper) {
        helper.searchWeather(component);
    },

    'init': function (component, event, helper) {
        component.set('v.columns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Location Name', fieldName: 'Location__c', type: 'text' },
            { label: 'Temperature °C', fieldName: 'Temperature__c', type: 'number' },
            { label: 'Timestamp', fieldName: 'Timestamp__c', type: 'date',
                typeAttributes: {
                    day: '2-digit',
                    month: 'short',
                    year: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit',
                    second: '2-digit',
                    hour12: true
                }
            }
        ]);

        helper.searchWeather(component);
        helper.fetchWeatherHistory(component);
    }
});
