({
    'searchWeather': function(component) {
        let searchLocation = component.get('v.location');
        let action = component.get('c.queryAPI');

        action.setParams({
            "location": searchLocation
        });

        action.setCallback(this, (response) => {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let data = response.getReturnValue();
                component.set('v.weatherInformation', data);
            } else {
                this.showToast('Error', 'Failed to search weather for this location!', 'error');
            }
        });

        $A.enqueueAction(action);
    },

    'showToast': function(title, message, type) {
        let toastEvent = $A.get('e.force:showToast');

        toastEvent.setParams({
            title,
            message,
            type
        });

        toastEvent.fire();
    },

    'fetchWeatherHistory': function(component) {
        const action = component.get('c.getAllWeatherHistoryByLocationForToday');
        action.setParams({
            'location': 'Lucknow, UP, India'
        });

        action.setCallback(this, (response) => {
            const state = response.getState();
            if (state === 'SUCCESS') {
                let data = response.getReturnValue();
                component.set('v.weatherData', data);
            } else {
                this.showToast('Error', 'Failed to fetch weather history!', 'error');
            }
        });

        $A.enqueueAction(action);
    }
});
