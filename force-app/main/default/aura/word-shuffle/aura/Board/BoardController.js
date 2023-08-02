({
	onInit: function (component, event, helper) {
		const gameMode = component.get('v.gameMode');
		let column = 0;
		if (gameMode === 'hard') {
			column = 6;
		} else if (gameMode == 'medium') {
			column = 4;
		} else {
			column = 3;
		}
		const blockSize = 12 / column;

		const words = helper.getWords(column * column);
		const winWord = helper.getWinWord(words);
		component.set('v.words', words);
		component.set('v.winWord', winWord);
		component.set('v.blockSize', blockSize);
		helper.resetBoard(component, event);
	},

	onRender: function (component, event, helper) {
		// helper.resetBlocks(component);
	},

	blockClickHandler: function(component, event, helper) {
		let clickCount = component.get('v.clickCount') + 1;
		const value = event.getParam('value');
		if (value === component.get('v.winWord')) {
			component.set('v.result', "You Won!");
			helper.disableBoard(component);
			helper.fireResultEvent('Win');
		} else if (clickCount === 3) {
			component.set('v.result', 'You Lost :(');
			helper.disableBoard(component);
			helper.fireResultEvent('Lose');
		}
		component.set('v.clickCount', clickCount);
	},

	reshuffleBoard: function(component, event, helper) {
		const words = component.get('v.words');
		const randomizedWords = helper.randomizeArray(words);
		component.set('v.words', words);
		helper.resetBoard(component, event);
	}
});
