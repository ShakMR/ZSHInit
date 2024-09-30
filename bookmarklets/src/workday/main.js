import {createButton, createDiv, createElementFromTemplate, createIconButton} from "../elementUtils";
import {addToDom, injectStyles} from "../dom";
import icon from './icons/icon';
import chevron from "./icons/chevron";
import {writeTimeTable} from "./workday_timesheets";
import daySelector from './day_selector';
import {default as daySelectorTemplate} from './templates/days-selector.html';

import styles from "./workday.css";

const addListenersForCheckboxes = (container) => {
    const checkboxes = container.querySelectorAll('input[type="checkbox"]');

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', ({target}) => daySelector.toggle(parseInt(target.name)));
        checkbox.checked = daySelector.days[parseInt(checkbox.name)];
    });
}

const setStartOrEndTime = (type, time) => {
    daySelector[type === 'start' ? 'setStartTime' : 'setEndTime'](time);
}

const addListenersForInputBoxes = (container) => {
    const inputs = container.querySelectorAll('input[type="number"]');
    inputs.forEach(input => {
        input.addEventListener('change', ({target}) => setStartOrEndTime(target.name, parseInt(target.value)));
    });
}

const addButtonsListeners = (container) => {
    const savePrefs = container.querySelector('#save-prefs');
    savePrefs.addEventListener('click', () => daySelector.savePreferences());
    const writeTime = container.querySelector('#set-times');
    writeTime.addEventListener('click', writeTimeTable);
}

const hiddenPanel = createDiv('workday-timesheets-panel');
const radioB = createElementFromTemplate(daySelectorTemplate);

addListenersForCheckboxes(radioB);
addListenersForInputBoxes(radioB);
addButtonsListeners(radioB)

const wrapper = createDiv('workday-timesheets-wrapper');
wrapper.appendChild(radioB);
const dragger = createIconButton('workday-timesheets-dragger', chevron, () => {hiddenPanel.classList.toggle('show')}, ['workdayTimesheetsDragger']);
hiddenPanel.appendChild(dragger);
hiddenPanel.appendChild(wrapper);
addToDom(hiddenPanel);
injectStyles(styles);
injectStyles(daySelector);
