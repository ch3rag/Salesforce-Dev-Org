({
    'startGame': function (component, event, helper) {
        let gameModeComboBox = component.find('gameMode');
        let selectedValue = gameModeComboBox.get('v.value');
        const selectedMode = component.get('v.selectedMode');

        component.set('v.selectedMode', selectedValue);

        if (selectedMode) {
            const boardComponent = component.find('boardComponent');

            boardComponent.startGame();
        }
    },

    'reshuffleBoard': function (component, event, helper) {
        const boardComponent = component.find('boardComponent');

        boardComponent.reshuffleBoard();
        component.set('v.reshuffleDisabled', true);
    },

    'onResultHandler': function (component, event, helper) {
        const result = event.getParam('result');

        if (result === 'Win') {
            component.set('v.reshuffleDisabled', true);
            helper.showToast('You Win!', 'Hurray!', 'Success');
        } else {
            component.set('v.reshuffleDisabled', false);
            helper.showToast('You Lose :(', 'Reshuffle the board to keep playing...', 'Error');
        }
        helper.addResultRecord(component, result);
    }
});
