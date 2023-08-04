({
    'onClickHandler': function (component, event, helper) {
        const open = component.get('v.open');

        if (!open) {
            component.set('v.open', true);
            const label = component.get('v.label');
            let componentEvent = component.getEvent('onclick');

            componentEvent.setParams({
                'value': label
            });
            componentEvent.fire();
        }
    },

    'afterScriptsLoaded': function (component, event, helpers) {
        window.fitText(component.getElement('.board-block'));
    }
});
