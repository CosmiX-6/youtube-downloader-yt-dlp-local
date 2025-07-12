// ==UserScript==
// @name         YouTube Downloader Button (yt-dlp Local)
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Injects a download button on YouTube watch pages that sends the video to local yt-dlp server
// @author       Akash
// @match        https://www.youtube.com/watch*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    function injectButton() {
        // Avoid injecting multiple times
        if (document.querySelector('#yt-dlp-download-button')) return;

        const container = document.querySelector('#top-level-buttons-computed');
        if (!container) return;

        const button = document.createElement('button');
        button.id = 'yt-dlp-download-button';
        button.innerText = 'Download with yt-dlp';
        button.style.marginLeft = '8px';
        button.style.padding = '6px 12px';
        button.style.fontSize = '14px';
        button.style.backgroundColor = '#ff0000';
        button.style.color = 'white';
        button.style.border = 'none';
        button.style.borderRadius = '4px';
        button.style.cursor = 'pointer';

        button.onclick = () => {
            const videoId = new URL(location.href).searchParams.get('v');
            if (!videoId) {
                alert('Invalid video ID.');
                return;
            }

            fetch(`http://localhost:8791/download?v=${videoId}`)
                .then(response => {
                    if (response.ok) {
                        alert('Download started.');
                    } else {
                        alert('Server error. Check if yt-dlp server is running.');
                    }
                })
                .catch(() => {
                    alert('Failed to connect to yt-dlp server.');
                });
        };

        container.appendChild(button);
    }

    // Watch for page content updates (YouTube uses dynamic routing)
    const observer = new MutationObserver(() => injectButton());
    observer.observe(document.body, { childList: true, subtree: true });

    // Initial attempt
    injectButton();
})();
