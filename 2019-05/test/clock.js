'use strict';
(() => {
  const timeEl = document.getElementById('time');
  const buttonEl = document.getElementById("sync-start");
  let startTime = null;

  const pad = val => val < 10 ? '0' + val : val;

  function setStartTime () {
    const now = new Date();
    startTime = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      now.getHours(),
      now.getMinutes() + 2 - (now.getMinutes() % 2),
      0,
      0
    );
  }

  function getClockTime () {
    const now = new Date();
    let msDiff = now - startTime;
    msDiff = Math.floor(msDiff / 1000) * 1000;
    const dateDiff = new Date(Math.abs(msDiff));

    return {
      hours: dateDiff.getUTCHours(),
      minutes: dateDiff.getUTCMinutes(),
      seconds: dateDiff.getUTCSeconds(),
      countdown: msDiff < 0
    };
  }

  function updateDOMClock (clockTime) {
    console.log(clockTime);
    const hours = clockTime.hours;
    const minutes = clockTime.minutes;
    const seconds = clockTime.seconds;

    timeEl.setAttribute('data-hours', pad(hours));
    timeEl.setAttribute('data-minutes', pad(minutes));
    timeEl.setAttribute('data-seconds', pad(seconds));
    timeEl.setAttribute('data-countdown', clockTime.countdown)
  }

  function startClock () {
    const animationFrame$ = Rx.Observable.interval(0, Rx.Scheduler.animationFrame);

    const time$ = Rx.Observable.interval(1000)
      .map(getClockTime)
      .subscribe(updateDOMClock);

    RxCSS({}, timeEl);
  }


  buttonEl.addEventListener("click", ev => {
    ev.preventDefault();
    buttonEl.classList.add("disabled");

    setStartTime();
    startClock();

    timeEl.classList.remove("disabled");
  });
})();
