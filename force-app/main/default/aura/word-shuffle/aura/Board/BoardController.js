({
    'onInit': function (component, event, helper) {
        const gameMode = component.get('v.gameMode');
        let columnCount = {
            'easy': 3,
            'medium': 4,
            'hard': 6
        };
        let gridWidth = 12;
        let numColumns = columnCount[gameMode];

        const blockSize = gridWidth / numColumns;
        const words = helper.getWords(numColumns * numColumns);
        const winWord = helper.getWinWord(words);

        component.set('v.words', words);
        component.set('v.winWord', winWord);
        component.set('v.blockSize', blockSize);
        helper.resetBoard(component, event);
    },

    'blockClickHandler': function (component, event, helper) {
        const NUM_MAX_TURNS = 3;

        let clickCount = component.get('v.clickCount');

        // Increment Click Count
        /* eslint-disable-next-line no-magic-numbers */
        clickCount += 1;

        const value = event.getParam('value');

        if (value === component.get('v.winWord')) {
            component.set('v.result', 'You Won!');
            helper.disableBoard(component);
            helper.fireResultEvent('Win');
        } else if (clickCount === NUM_MAX_TURNS) {
            component.set('v.result', 'You Lost :(');
            helper.disableBoard(component);
            helper.fireResultEvent('Lose');
        }

        component.set('v.clickCount', clickCount);
    },

    'reshuffleBoard': function (component, event, helper) {
        const words = component.get('v.words');

        helper.randomizeArray(words);

        component.set('v.words', words);
        helper.resetBoard(component, event);
    }
});
