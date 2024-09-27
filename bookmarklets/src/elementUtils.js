export const isElementVisible = function (elem) {
  return !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length);
};

export const extractCookie = (cookieName) => {
  const cookie = document.cookie.split(';')
    .map(c => c.trim())
    .find(c => c.startsWith(cookieName));
  return cookie ? cookie.split('=')[1] : '';
}

export const extractURLParam = (param) => {
  const url = new URL(window.location.href);
  return url.searchParams.get(param);
}

const createImg = (iconImg) => {
  const img = document.createElement('img');
  img.src = iconImg;
  return img;
}

export const createIconButton = (id, iconImg, onClick, classNames=[id]) => {
  const div = createDiv(id);
  div.addEventListener('click', onClick);
  classNames.forEach(className => div.classList.add(className));
  const icon = createImg(iconImg);
  div.appendChild(icon);
  return div;
}

export const createFloatingIcon = (id, iconImg, onClick) => {
  const createIconImage = () => {
    const icon = document.createElement('img');
    icon.src = iconImg;
    icon.style.width = '50px';
    icon.style.height = '50px';
    icon.setAttribute('id', id);
    return icon;
  }

  const createDiv = (content) => {
    const div = document.createElement('div');
    div.classList.add(id);
    div.style.position = 'fixed';
    div.style.top = '10%';
    div.style.right = '10%';
    div.style.zIndex = '9999';
    div.style.cursor = 'pointer';
    div.style.borderRadius = '1px solid black';
    div.style.backgroundColor = 'rgba(1, 1, 1, 1)';
    div.style.opacity = 0.5;
    div.setAttribute('id', id);
    div.addEventListener('click', onClick);
    div.append(content);
    return div;
  }

  document.body.appendChild(
    createDiv(
      createIconImage()
    )
  );
}

export const createFloatingDiv = (id, onClose, content, show=false) => {
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

export const replaceTemplate = (htmlString, params) => {
  let finalHtml = htmlString;
  for (const key in params) {
    finalHtml = finalHtml.replaceAll(`{{${key}}}`, params[key]);
  }
  return finalHtml;
}

export const createDiv = (id) => {
  const wrapper = document.createElement('div');
  if (id) {
    wrapper.setAttribute('id', id);
  }
  return wrapper;
}

export const hideElement = (element) => {
  element.style.display = 'none';
}

