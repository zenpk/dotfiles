// ==UserScript==
// @name         X.com - Redirect to Following + Hide Retweets Toggle
// @namespace    https://tampermonkey.net/
// @version      1.1
// @description  Always open Following timeline and optionally hide retweets.
// @author       You
// @match        https://x.com/*
// @match        https://twitter.com/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    const STORAGE_KEY = "hideRetweets";

    // --------------------
    // Redirect to Following
    // --------------------
    function redirect() {
        const url = new URL(location.href);

        if (
            url.pathname === "/home" &&
            url.searchParams.get("filter") !== "following"
        ) {
            url.searchParams.set("filter", "following");
            location.replace(url.toString());
        }
    }

    redirect();

    // --------------------
    // Toggle UI
    // --------------------
    function createToggle() {
        if (document.getElementById("tm-hide-rt-toggle")) return;

        const btn = document.createElement("button");
        btn.id = "tm-hide-rt-toggle";

        Object.assign(btn.style, {
            position: "fixed",
            top: "16px",
            right: "16px",
            zIndex: "999999",
            padding: "8px 12px",
            borderRadius: "20px",
            border: "none",
            cursor: "pointer",
            background: "#1d9bf0",
            color: "white",
            fontSize: "14px",
            fontFamily: "sans-serif"
        });

        function refresh() {
            const enabled = localStorage.getItem(STORAGE_KEY) === "true";
            btn.textContent = "Hide RTs: " + (enabled ? "ON" : "OFF");
            hideRetweets();
        }

        btn.onclick = () => {
            const enabled = localStorage.getItem(STORAGE_KEY) === "true";
            localStorage.setItem(STORAGE_KEY, (!enabled).toString());
            refresh();
        };

        document.body.appendChild(btn);
        refresh();
    }

    // --------------------
    // Hide / Show Retweets
    // --------------------
    function hideRetweets() {
        const enabled = localStorage.getItem(STORAGE_KEY) === "true";

        document.querySelectorAll("article").forEach(article => {
            const text = article.innerText.toLowerCase();

            const isRetweet =
                text.includes("retweeted") ||
                text.includes("reposted");

            if (!isRetweet) return;

            article.style.display = enabled ? "none" : "";
        });
    }

    // --------------------
    // Observe SPA navigation
    // --------------------
    let lastUrl = location.href;

    const observer = new MutationObserver(() => {
        if (location.href !== lastUrl) {
            lastUrl = location.href;
            redirect();
        }

        if (document.body) {
            createToggle();
        }

        hideRetweets();
    });

    observer.observe(document, {
        childList: true,
        subtree: true
    });

})();
