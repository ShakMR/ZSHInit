const isElementVisible = function (elem) {
  return !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length);
};

const extractCookie = (cookieName) => {
  const cookie = document.cookie.split(';')
    .map(c => c.trim())
    .find(c => c.startsWith(cookieName));
  return cookie ? cookie.split('=')[1] : '';
}

const extractURLParam = (param) => {
  const url = new URL(window.location.href);
  return url.searchParams.get(param);
}

const createFloatingIcon = (id, iconImg, onClick) => {
  const createIconImage = () => {
    const icon = document.createElement('img');
    icon.src = iconImg;
    icon.style.width = '50px';
    icon.style.height = '50px';
    icon.setAttribute('id', id);
    return icon;
  }

  const createDiv = () => {
    const div = document.createElement('div');
    div.style.position = 'fixed';
    div.style.top = '10%';
    div.style.right = '10%';
    div.style.zIndex = '9999';
    div.style.cursor = 'pointer';
    div.style.borderRadius = '1px solid black';
    div.style.backgroundColor = 'rgba(0, 0, 0, 0.8)';
    div.setAttribute('id', id);
    div.addEventListener('click', onClick);
    return div;
  }

  document.body.appendChild(
    createDiv(
      createIconImage()
    )
  );
}

const createFloatingDiv = (id, onClose, content, show=false) => {
  const div = document.createElement('div');
  div.style.position = 'fixed';
  div.style.top = '10%';
  div.style.right = '10%';
  div.style.zIndex = '9999';
  div.style.cursor = 'pointer';
  div.style.borderRadius = '1px solid black';
  div.style.backgroundColor = 'rgba(0, 0, 0, 0.8)';
  div.style.display = show ? 'inherit' : 'none';
  div.innerHTML = content;
  div.setAttribute('id', id);
  div.addEventListener('click', onClose);

  document.body.appendChild(div);

}

const replaceTemplate = (htmlString, params) => {
  let finalHtml = htmlString;
  for (const key in params) {
    finalHtml = finalHtml.replace(`{{${key}}}`, params[key]);
  }
  return finalHtml;
}

module.exports = {
  isElementVisible,
  extractCookie,
  createFloatingIcon,
  extractURLParam,
  replaceTemplate,
  createFloatingDiv
}
