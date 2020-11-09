const input = document.getElementById('code');
const button = document.getElementById('download_btn');
const msg = document.querySelector('.message')

button.addEventListener('click', () => {
    const val = input.value;
    if (val.length > 0) {
        displayMessage("Your download will begin shortly...");
        window.open("https://fileninja.tk/appdata/download.php?token=" + val, "_self");
    } else {
        displayMessage("Please enter a code first!");
    }
})

input.addEventListener("keyup", function(e) {
    if (e.key == 'Enter' || e.keyCode === 13) {
      button.click();
    }
  });
  
function displayMessage(text){
    msg.textContent = text;
}