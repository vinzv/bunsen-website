/*
 * If the user accesses the site using a non-SSL connection, an opened,
 * red padlock is displayed which upon clicking will redirect the user
 * to the HTTPS version.
 */

function include_lock(anchor, image) {
  if(window.location.protocol === 'https:') return;

  var node = document.querySelector(anchor);
  if(node===null) return;

  var a = document.createElement("a");
  a.setAttribute("href", "https://"+window.location.host + window.location.pathname);
  a.setAttribute("title", "Switch to a SSL-secured connection");

  var img = document.createElement("img");
  img.setAttribute("src", image);

  a.appendChild(img);
  node.appendChild(a);
};

const PADLOCK_IMAGE = "/img/numix_lock.svg";
const PADLOCK_ANCHOR = ".padlock";
include_lock(PADLOCK_ANCHOR, PADLOCK_IMAGE);
