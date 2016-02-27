/* BL status page */

"use strict";

function success(anchor)
{
  let n = document.getElementById(anchor);

  if(n.firstChild)
    n.removeChild(n.firstChild);

  let b = document.createElement("div");
  b.setAttribute("class", "status-success");

  let p = document.createElement("p");
  p.textContent = "Operating normally.";
  b.appendChild(p);

  n.appendChild(n);
}

function failure(anchor)
{
  let n = document.getElementById(anchor);

  if(n.firstChild)
    n.removeChild(n.firstChild);

  let b = document.createElement("div");
  b.setAttribute("class", "status-failure");

  let p = document.createElement("p");
  p.textContent = "Dysfunctional.";
  b.appendChild(p);

  n.appendChild(n);
}

function bl_status()
{
  return;
}

function () { window.setInterval(bl_status, 2000); }();
