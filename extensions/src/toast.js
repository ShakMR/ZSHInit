export const showToast = (text) => {
    const div = document.createElement('div');
    div.setAttribute('id', 'switch-toast');
    div.style.position = 'fixed';
    div.style.bottom = '10%';
    div.style.left = '50%';
    div.style.transform = 'translateX(-50%)';
    div.style.backgroundColor = 'rgba(0, 0, 0, 0.8)';
    div.style.color = 'white';
    div.style.padding = '1rem';
    div.style.zIndex = '9999';
    div.style.borderRadius = '5px';
    div.style.transition = 'opacity 0.5s linear';
    div.style.opacity = '1';
    div.innerText = text;
    document.body.appendChild(div);
    setTimeout(() => {
        document.getElementById('switch-toast').style.opacity = '0';
        setTimeout(() => {
            document.getElementById('switch-toast').remove();
        }, 500);
    }, 2000);
}
