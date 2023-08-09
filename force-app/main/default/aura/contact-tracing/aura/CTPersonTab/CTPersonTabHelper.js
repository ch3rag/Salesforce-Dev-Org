({
    'fetchUserInformation': function (component) {
        let recordId = component.get('v.recordId');
        let action = component.get('c.getPersonDetails');

        action.setParams({
            recordId
        });

        action.setCallback(this, (response) => {
            let state = response.getState();

            if (state === 'SUCCESS') {
                let data = response.getReturnValue();

                if (!data || !data.name) {
                    component.set('v.userFound', false);
                    this.showToast('Error', 'Please enter valid User Id!', 'error');
                } else {
                    component.set('v.userFound', true);
                    component.set('v.userInfo', data);
                }
            } else {
                component.set('v.userFound', false);
                this.showToast('Error', 'Please enter valid User Id!', 'error');
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