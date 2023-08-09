({
    'updateStatus': function (component) {
        let recordId = component.get('v.recordId');
        let action = component.get('c.updateHealthStatus');

        action.setParams({
            'personId': recordId
        });

        action.setCallback(this, (response) => {
            const state = response.getState();

            if (state === 'SUCCESS') {
                this.showToast('Success', 'Person Health Status Updated!', 'success');
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