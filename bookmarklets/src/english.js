const focusLastCheck = () => {
  const allChecks = document.querySelectorAll('span.w-4.h-4')
  const element = Array.from(allChecks).reverse()[0];
  scrollToElement(element);
}

function getAbsolutePosition(element) {
  const rect = element.getBoundingClientRect();
  const scrollLeft = window.pageXOffset || document.documentElement.scrollLeft;
  const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

  return {
    top: rect.top + scrollTop,
    left: rect.left + scrollLeft,
    bottom: rect.bottom + scrollTop,
    right: rect.right + scrollLeft
  };
}

function scrollToElement(element) {
  if (element) {
    const parentElement = element.parentElement?.parentElement;
    const topPosition = getAbsolutePosition(parentElement).top;
    window.scrollTo({top: topPosition, behavior: 'smooth'});
  } else {
    console.warn(`No element found for the selector: ${selector}`);
  }
}