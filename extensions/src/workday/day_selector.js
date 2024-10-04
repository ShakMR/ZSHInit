const transformText = (text) => text === 'mie' ? 'mié' : text;

class DaySelector {
  constructor() {
    //           dom    lun    mar    mie    jue    vie    sab
    this.days = [false, false, false, false, false, false, false];
    this.times = { start: 9, end: 17 };
    this.restorePreferences();
  }

  toggle(dayIndex) {
    this.days[dayIndex] = !this.days[dayIndex];
  }

  toggleAll() {
    this.days = this.days.map(day => !day);
  }

  setStartTime(time) {
    this.times.start = time;
  }

  setEndTime(time) {
    this.times.end = time;
  }

  getActiveDays() {
    return this.days
  }

  getActiveHours() {
    return this.times;
  }

  savePreferences() {
    localStorage.setItem('selectedDays', JSON.stringify(this.days));
    localStorage.setItem('selectedTimes', JSON.stringify(this.times));
  }

  restorePreferences() {
    const selectedDays = localStorage.getItem('selectedDays');
    if (selectedDays) {
      this.days = JSON.parse(selectedDays);
    }
    const selectedTimes = localStorage.getItem('selectedTimes');
    if (selectedTimes) {
      this.times = JSON.parse(selectedTimes);
    }
  }
}
window.daySelector = new DaySelector();
export default daySelector;
