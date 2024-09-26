import {getAccountInput, getAccountName, getRoleDescription} from "./selectors";

const ID_SEPARATOR = '__';

/**
 * @typedef Account
 * @property {string} name
 * @property {HTMLElement} checkbox
 * @property {string} roleDescription
 * @property {string} stage
 * @property {string} service
 * @property {string} roleId
 *
 * @param wrapper
 * @returns {Account}
 */
export const getAccountInfo = (wrapper) => {
  const accountName = getAccountName(wrapper);
  const accountInput = getAccountInput(wrapper);
  const roleDescription = getRoleDescription(wrapper);
  const moreInfo = extractAccountNameInfo(accountName.innerText);
  return {
    name: accountName.innerText,
    checkbox: accountInput,
    roleDescription: roleDescription.innerText,
    ...moreInfo,
    roleId: getAccountId(moreInfo),
  };
}

const getAccountId = ({service, stage}) => {
  return `${service}${ID_SEPARATOR}${stage}`;
}

const getInfoFromId = (id) => {
  const [service, stage] = id.split(ID_SEPARATOR);
  return {service, stage};
}

const extractServiceAccountInfo = (name) => {
  // Account: tlz-event-listing-webapp-preprod-654654610074 (654654610074)
  // create a regex to extract the service name and the stage so the pattern
  // is something like tlz-serviceName-stage-accountId service name can contain hyphens
  const regex = /tlz-(.*)-([a-zA-Z]*)-(\d+)/;
  const match = name.match(regex);

  if (!match) {
    return {
      service: 'unknown',
      stage: 'unknown',
    }
  }

  return {
    service: match[1],
    stage: match[2],
  }
}

const extractOrchestrationAccountInfo = (name) => {
  // Account: orchestration-orchestration-654654610074 (654654610074)
  const regex = /tlz-orchestration-(.*)-(\d+)/;
  const match = name.match(regex);

  console.log(match);

  if (!match) {
    return {
      service: 'unknown',
      stage: 'unknown',
    }
  }

  return {
    service: match[1],
    stage: 'orchestration',
  }
}


const extractAccountNameInfo = (name) => {
  if (name.includes('orchestration')) {
    return extractOrchestrationAccountInfo(name);
  }

  return extractServiceAccountInfo(name);
}

/**
 *
 * @param {Account[]} accounts
 * @returns {Record<string, Account[]>}
 */
export const groupAccountsBasedOnName = (accounts) => {
  const groupedAccounts = {};
  for (const account of accounts) {
    const name = account.service;
    if (!groupedAccounts[name]) {
      groupedAccounts[name] = [];
    }
    groupedAccounts[name].push(account);
  }
  return groupedAccounts;

}
