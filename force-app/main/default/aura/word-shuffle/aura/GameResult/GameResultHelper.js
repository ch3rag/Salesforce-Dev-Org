({
	fetchResults: function(component) {
		const action = component.get('c.getResults');
		action.setCallback(this, (response) => {
			const state = response.getState();
			if (state === 'SUCCESS') {
				const results = response.getReturnValue();
				component.set('v.data', results);
			}
		});

		$A.enqueueAction(action);
	}
})
