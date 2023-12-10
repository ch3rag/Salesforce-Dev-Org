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
                component.set('v.resolvedAddress', data.resolvedAddress);
                component.set('v.currentTemperature', data.currentTemperature + ' °C');
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
    }
});

