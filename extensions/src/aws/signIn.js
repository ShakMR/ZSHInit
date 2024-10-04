import {SELECTORS} from "./selectors";

export const clickSignIn = () => {
  const signInButton = document.querySelector(SELECTORS.signInButton);
  signInButton.click();
}
