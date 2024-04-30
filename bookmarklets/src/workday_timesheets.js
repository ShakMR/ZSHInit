const showToast = require('./toast');
const {isElementVisible} = require('./elementUtils');

const DELAY_MS = 500;

const elements = {
    tabBar: 'ul[data-automation-id=tabBar]',
    entryRow: '[data-automation-id=wd-ActiveListRowEditor-New]',
    inputElements: '[data-automation-id=standaloneTimeWidget] > input',
    okButton: '[data-automation-id=wd-CommandButton_uic_okButton]'
}


const getTabButtonsForWorkingDays = (workingDaysArray) => {
    return Array.from(document.querySelector(elements.tabBar).children)
        .filter(tabEl => workingDaysArray.some((day) => tabEl.innerHTML.includes(day) && isElementVisible(tabEl)));
}

const selectTab = async (tab) => {
    showToast(`Selecting tab ${tab.innerText}`);
    tab.click();
    await userDelay(DELAY_MS);
}

const writeInput = async (input, time) => {
    console.log('Writing time', input, time);
    input.style.border = "1px solid green";
    input.dispatchEvent(new Event('focus'));
    await userDelay(DELAY_MS/10);
    input.value = time;
    await userDelay(DELAY_MS/10);
    await input.dispatchEvent(new Event('change', {bubbles: true}));
    await input.dispatchEvent(new Event('blur'));
    await userDelay(DELAY_MS);
}

const userDelay = (timeMs) => new Promise(resolve => setTimeout(resolve, timeMs));

const getVisibleRowElement = () => Array.from(document.querySelectorAll(elements.entryRow)).filter(isElementVisible);

const getInputControlsFromRowElement = (rowElement) => Array.from(rowElement.querySelectorAll(elements.inputElements)).filter(isElementVisible);

const setTimeForDay = async (workingHours) => {
    const entryRowElement = getVisibleRowElement();
    const [startInput, endInput] = getInputControlsFromRowElement(entryRowElement[0]);

    await writeInput(startInput, workingHours.start);
    await writeInput(endInput, workingHours.end);
}

const clickOkButton = () => {
    document.querySelector('[data-automation-id=wd-CommandButton_uic_okButton]').click();
}

const main = async () => {
    const workingDays = ['lun', 'mar', 'mié', 'jue', 'vie'];
    const workingHours = {
        start: 9,
        end: 17,
    };

    const selectedDays = prompt('Enter working days (lun, mar, mié, jue, vie)', workingDays.join(',')).split(',');

    const tabButtons = getTabButtonsForWorkingDays(selectedDays);

    for (const tab of tabButtons) {
        selectTab(tab);
        await setTimeForDay(workingHours);
        await userDelay(DELAY_MS);
    }

    clickOkButton();
}

main();
