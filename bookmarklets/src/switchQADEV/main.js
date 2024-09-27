import {showToast} from '../toast';
import {createIconButton} from "../elementUtils";

import styles from './switch.css';
import {addToDom, injectStyles} from "../dom";

const icon = "data:image/png;base64,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";

const dev = {
    host: process.env.DEV_HOST,
    port: '3000'
}
const qa = {
    host: process.env.QA_HOST,
    port: '',
}

const switchQADEV = () => {
    let href;
    const currentPort = window.location.port;
    if (currentPort === dev.port) {
        showToast('Switching to QA');
        const regex = new RegExp(`${dev.host}\.(.*):${dev.port}`, 'g');
        console.log(regex);
        href = window.location.href.replace(regex, `${qa.host}.$1`);
    } else {
        showToast('Switching to DEV');
        const regex = new RegExp(`${qa.host}\.([a-z]{2,3})\/`, 'g');
        console.log(regex);
        href = window.location.href.replace(regex, `${dev.host}.$1:${dev.port}/`);
    }
    console.log(href, window.location.href)
    setTimeout(() => {
        window.location.href = href;
    }, 1000);
}

const currentPort = window.location.port;
const isCurrentDev = currentPort === dev.port;

const button = createIconButton('switchQADEV', icon, switchQADEV, ['switchQADEV', isCurrentDev ? 'dev' : 'qa']);
addToDom(button);
injectStyles(styles);
