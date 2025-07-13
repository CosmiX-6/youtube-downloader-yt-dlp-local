// ==UserScript==
// @name         YouTube Downloader Floating Button (yt-dlp Local)
// @namespace    http://tampermonkey.net/
// @version      1.0.0
// @license      MIT
// @description  Floating premium-style download button with hide on fullscreen and toggle shortcut (Shift+D)
// @author       Akash
// @match        https://www.youtube.com/watch*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    const BUTTON_ID = 'yt-dlp-floating-download-btn';
    let visible = true;

    function createFloatingButton() {
        if (document.getElementById(BUTTON_ID)) return;

        const btn = document.createElement('button');
        btn.id = BUTTON_ID;
        btn.textContent = '⬇ Download';
        Object.assign(btn.style, {
            position: 'fixed',
            bottom: '20px',
            right: '20px',
            zIndex: '9999',
            padding: '14px 22px',
            backgroundColor: '#0f0f0f',
            color: '#fff',
            fontSize: '15px',
            fontWeight: '500',
            fontFamily: 'Inter, Segoe UI, Roboto, sans-serif',
            border: '1px solid rgba(255,255,255,0.1)',
            borderRadius: '999px',
            boxShadow: '0 4px 14px rgba(0,0,0,0.2)',
            backdropFilter: 'blur(10px)',
            transition: 'all 0.25s ease-in-out',
            cursor: 'pointer',
            userSelect: 'none',
            outline: 'none',
        });

        btn.addEventListener('mouseenter', () => {
            btn.style.backgroundColor = '#ffffff';
            btn.style.color = '#0f0f0f';
            btn.style.border = '1px solid rgba(0,0,0,0.1)';
            btn.style.boxShadow = '0 6px 20px rgba(0,0,0,0.25)';
        });

        btn.addEventListener('mouseleave', () => {
            btn.style.backgroundColor = '#0f0f0f';
            btn.style.color = '#ffffff';
            btn.style.border = '1px solid rgba(255,255,255,0.1)';
            btn.style.boxShadow = '0 4px 14px rgba(0,0,0,0.2)';
        });

        btn.onclick = () => {
            const videoId = new URL(location.href).searchParams.get('v');
            if (!videoId) return alert('Invalid video ID.');
            fetch(`http://localhost:8791/download?v=${videoId}`)
                .then(res => {
                    if (res.ok) alert('Download started.');
                    else alert('Server error. Is yt-dlp server running?');
                })
                .catch(() => alert('Failed to connect to yt-dlp server.'));
        };

        document.body.appendChild(btn);
    }

    function toggleButtonVisibility(force) {
        const btn = document.getElementById(BUTTON_ID);
        if (!btn) return;
        visible = typeof force === 'boolean' ? force : !visible;
        btn.style.display = visible ? 'block' : 'none';
    }

    function handleFullscreenChange() {
        const isFullscreen = !!(document.fullscreenElement || document.webkitFullscreenElement);
        toggleButtonVisibility(!isFullscreen);
    }

    function init() {
        createFloatingButton();
        document.addEventListener('fullscreenchange', handleFullscreenChange);
        document.addEventListener('webkitfullscreenchange', handleFullscreenChange);

        document.addEventListener('keydown', e => {
            if (e.shiftKey && e.code === 'KeyD') toggleButtonVisibility();
        });
    }

    // SPA-aware
    const observer = new MutationObserver(() => {
        if (window.location.href.includes('watch')) init();
    });
    observer.observe(document.body, { childList: true, subtree: true });

    // Initial injection
    window.addEventListener('load', init);
})();
