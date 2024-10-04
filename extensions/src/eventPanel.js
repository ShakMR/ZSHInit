const {extractCookie, createFloatingIcon, extractURLParam, replaceTemplate, createFloatingDiv} = require("./elementUtils");

if (!window.__SERVER_DATA__) {
  window.__SERVER_DATA__ = require('../fixtures/server_data.json');
}

const getEvent = () => {
  return __SERVER_DATA__.event;
}

const getAppInfo = () => {
  return {
    name: __SERVER_DATA__.app_name,
    version: __SERVER_DATA__.app_version,
  };
}

const repeatingEventInfo = () => {
  return {
    isRepeating: __SERVER_DATA__.event.isRepeating,
    isParent: __SERVER_DATA__.event.isSeriesParent,
    isChild: !__SERVER_DATA__.event.isSeriesParent,
  };
};

const stableID = () => {
  return {
    cookie: extractCookie('stableId'),
    url: extractURLParam('stableID'),
    server: __SERVER_DATA__.stableId,
  }
}

const organizerInfo = () => {
  return __SERVER_DATA__.organizer;
}

const extensionIcon = 'https://cdn-icons-png.flaticon.com/512/2558/2558944.png';

const createPanel = () => {
  const panelHtml = require('./panel/html.html');
  const panelDiv = replaceTemplate(panelHtml, {
    app_name: getAppInfo().name,
    app_version: getAppInfo().version,
    name: getEvent().name,
    id: getEvent().id,
    isRepeating: repeatingEventInfo().isRepeating,
    isParent: repeatingEventInfo().isParent,
    isChild: repeatingEventInfo().isChild,
    stable_cookie: stableID().cookie,
    stable_url: stableID().url,
    stable_server: stableID().server,
    org_id: organizerInfo().id,
  });
  createFloatingDiv('event-panel', () => {
    document.getElementById('event-panel').style.display = 'none';
  }, panelDiv);
}

createPanel();
createFloatingIcon("event-panel-trigger", extensionIcon, () => {
  document.getElementById('event-panel').style.display = 'inherit';
});
