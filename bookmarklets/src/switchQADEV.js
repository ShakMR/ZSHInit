const showToast = require('./toast');

const currentPort = window.location.port;

const dev = {
    host: 'dev.***REMOVED***',
    port: '3000'
}
const qa = {
    host: 'www.***REMOVED***',
    port: '',
}

const switchQADEV = () => {
    let href;
    if (currentPort === dev.port) {
        showToast('Switching to QA');
        const regex = new RegExp(`${dev.host}\.(.*):${dev.port}`, 'g');
        href = window.location.href.replace(regex, `${qa.host}.$1`);
    } else {
        showToast('Switching to DEV');
        const regex = new RegExp(`${qa.host}\.([a-z]{2,3})\/`, 'g');
        href = window.location.href.replace(regex, `${dev.host}.$1:${dev.port}/`);
    }
    setTimeout(() => {
        window.location.href = href;
    }, 1000);
}

switchQADEV();
