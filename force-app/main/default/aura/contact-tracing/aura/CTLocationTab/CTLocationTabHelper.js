({
    'fetchLocationInformation': function (component) {
        let recordId = component.get('v.recordId');
        let action = component.get('c.getLocationDetails');

        action.setParams({
            recordId
        });

        action.setCallback(this, (response) => {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let data = response.getReturnValue();

                if (!data || !data.name) {
                    component.set('v.userFound', false);
                    this.showToast('Error', 'Please enter valid Location Id!', 'error');
                } else {
                    component.set('v.locationFound', true);
                    component.set('v.locationInfo', data);
                }
            } else {
                component.set('v.locationFound', false);
                this.showToast('Error', 'Please enter valid Location Id!', 'error');
            }
        });
        $A.enqueueAction(action);
    },

    'showToast': function (title, message, type) {
        let toastEvent = $A.get('e.force:showToast');

        toastEvent.setParams({
            title,
            message,
            type
        });

        toastEvent.fire();
    }
});