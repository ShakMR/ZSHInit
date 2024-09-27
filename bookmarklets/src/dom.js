export const injectStyles = (styles) => {
  document.head.innerHTML = document.head.innerHTML + styles;
}

export const addToDom = (element) => {
  document.body.appendChild(element);
}
