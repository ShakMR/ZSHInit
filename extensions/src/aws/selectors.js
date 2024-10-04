
export const SELECTORS = {
  accountWrapper: 'fieldset > .saml-account',
  accountName: '.expandable-container .saml-account-name',
  accountInput: 'input[type="radio"].saml-radio',
  roleDescription: '.saml-account .saml-role-description',
  form: '#saml_form',
  signInButton: '#signin_button',
}

export const DYNAMIC_SELECTORS = {
  accountContainer: (accountName) => `#${accountName}-wrapper`,
  accountRolesContainer: (accountName) => `#${accountName}-wrapper .rolesContainer`
}

export const getAccountWrappers = () => Array.from(document.querySelectorAll(SELECTORS.accountWrapper));
export const getAccountName = (wrapper) => wrapper && wrapper.querySelector(SELECTORS.accountName);
export const getAccountInput = (wrapper) => wrapper && wrapper.querySelector(SELECTORS.accountInput);
export const getRoleDescription = (wrapper) => wrapper && wrapper.querySelector(SELECTORS.roleDescription);
export const getRolesContainer = (service, container = null) => {
  return (container || document).querySelector(DYNAMIC_SELECTORS.accountRolesContainer(service));
}
