import os
import subprocess
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs
from plyer import notification
from datetime import datetime

DOWNLOAD_DIR = os.path.join(os.environ["USERPROFILE"], "Downloads/Youtube-Downloaded-Videos")
YT_DLP_CMD = [
    "yt-dlp",
    "-o", os.path.join(DOWNLOAD_DIR, "%(title).50s.%(ext)s"),
    "-f", "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4",
    "--merge-output-format", "mp4"
]

class DownloadRequestHandler(BaseHTTPRequestHandler):
    def _send_response(self, code=204, message=""):
        self.send_response(code)
        self.send_header("Content-type", "text/plain")
        self.send_header("Access-Control-Allow-Origin", "*")  # For CORS
        self.end_headers()
        self.wfile.write(message.encode())

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        self.end_headers()

    def do_GET(self):
        # Ignore browser's request for favicon.ico
        if self.path.startswith("/favicon.ico"):
            self._send_response(204)
            return

        parsed = urlparse(self.path)
        query = parse_qs(parsed.query)
        video_id = query.get("v", [""])[0]

        if not video_id:
            self._send_response(400, "Missing video ID")
            return

        video_url = f"https://www.youtube.com/watch?v={video_id}"
        timestamp = datetime.now().strftime("[%H:%M:%S]")
        print(f"{timestamp} Request received: {video_url}")

        # Notify user
        notification.notify(
            title="yt-dlp",
            message=f"Download started:\n{video_url}",
            timeout=5
        )

        # Start yt-dlp in background
        subprocess.Popen(
            YT_DLP_CMD + [video_url],
            creationflags=subprocess.CREATE_NO_WINDOW
        )

        self._send_response(200, "Download started")

def run_server(port=8791):
    server = ThreadingHTTPServer(('localhost', port), DownloadRequestHandler)
    print(f"[{datetime.now().strftime('%H:%M:%S')}] yt-dlp server running on http://localhost:{port}")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")

if __name__ == "__main__":
    run_server()
