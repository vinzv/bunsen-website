function include_lock() {
  var node = document.querySelector(".padlock");
  if(node===null) return;
  if(window.location.protocol != 'https:') {
    var a = document.createElement("a");
    a.setAttribute("href", "https://"+window.location.host + window.location.pathname);
    a.setAttribute("title", "Switch to a SSL-secured connection");
    var img = document.createElement("img");
    img.setAttribute("src", "img/numix_lock.svg");
    a.appendChild(img);
    node.appendChild(a);
  }
};
include_lock();
