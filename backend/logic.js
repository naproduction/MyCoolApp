(function(){
  function updateClicks(){
    const el = document.getElementById('clickCount');
    const n = Number(localStorage.getItem('clicks')||0);
    el.textContent = 'Clicks: ' + n;
  }

  window.sayHello = function(){
    const n = Number(localStorage.getItem('clicks')||0) + 1;
    localStorage.setItem('clicks', String(n));
    alert('Hello boss! Your Termux-built app says hi 👋');
    updateClicks();
  };

  document.addEventListener('DOMContentLoaded', function(){
    // Wire button
    const b = document.getElementById('helloBtn');
    if(b) b.addEventListener('click', sayHello);

    // copy logic.js into www at build time; also, if bundled, it will load
    updateClicks();
  });
})();
