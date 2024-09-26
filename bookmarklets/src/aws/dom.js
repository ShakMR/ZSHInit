import {SELECTORS} from "./selectors";
import {createDiv, hideElement, replaceTemplate} from "../elementUtils";
import styles from "./aws.css";

export const hideForm = () => {
  hideElement(document.querySelector(SELECTORS.form))
}

export const createElementWithWrapper =  (template, data) => {
  const filledTemplate = replaceTemplate(template, data);
  const wrapper = createDiv();
  wrapper.innerHTML = filledTemplate;
  return wrapper;
}

export const createElement = (template, data) => {
  return createElementWithWrapper(template, data).children[0];
}

export const addClickListener = (id, fn, container = document) => {
  container.querySelector(`#${id}`).addEventListener('click', fn);
}

const injectStyles = (styles) => {
  document.head.innerHTML = document.head.innerHTML + styles;
}

export const replaceForm = (element) => {
  document.body.insertBefore(element, document.body.firstChild);
  injectStyles(styles);
  hideForm();
}
