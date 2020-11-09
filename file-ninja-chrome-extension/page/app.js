const input = document.getElementById('code');
const button = document.getElementById('download_btn');
const msg = document.querySelector('.message')

button.addEventListener('click', () => {
    const val = input.value;
    if (val.length > 0) {
        displayMessage("Download will begin shortly...");
        chrome.tabs.create({url: "https://fileninja.tk/appdata/download.php?token=" + val});
    } else {
        displayMessage("Please enter a code first")
    }
})

input.addEventListener("keyup", function(e) {
    const key = e.key;
    const keyCode = e.keyCode;
    if (e.key == 'Enter' || e.keyCode === 13) {
      button.click();
    }
  });
  
function displayMessage(text){
    msg.textContent = text;
}
