function sayHello(){
  alert("Hello boss! Your cloud-built APK is alive 🎉");
  // Example: simple key-value persistence
  const n = Number(localStorage.getItem("clicks")||0)+1;
  localStorage.setItem("clicks", String(n));
  console.log("Clicks:", n);
}
