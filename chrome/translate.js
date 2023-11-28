// ==UserScript==
// @name         My
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  useful shortcuts
// @author       You
// @match        *://*/*
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

document.addEventListener("keydown", callMyBar)

function callMyBar(evt) {
    if (evt.ctrlKey && evt.key === "/") {
        // let text = prompt("Google Search", "");
        // if (text.length <= 0) {
        //     return;
        // }
        // let form = document.createElement("form");
        // form.target = "_blank"
        // form.action = "https://google.com/search";
        // form.method = "GET";
        // form.innerHTML = `<input type="hidden" name="q" value=${text}>`;
        // document.body.appendChild(form);
        // form.submit();
        // document.body.removeChild(form);
        // // open("https://google.com/search?q=" + text);
    }
    if (evt.ctrlKey && evt.key === ".") {
        let text = window.getSelection().toString();
        text = prompt("Google Translate", text);
        if (text.length <= 0) {
            return;
        }
        let params = `scrollbars=no,resizable=no,status=no,location=no,toolbar=no,menubar=no,
width=1280,height=480,left=100,top=100`;
        open("https://translate.google.com/?sl=auto&tl=zh-CN&text=" + text + "&op=translate", "translation", params);
    }
}

