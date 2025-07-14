# Local YouTube video downloader: A Self-Hosted YouTube Downloader

[![runs with python](https://img.shields.io/badge/python-3.12-blue)](https://www.python.org/downloads/)

This project provides a powerful and seamless **YouTube downloader** that allows for **offline video download** directly from the YouTube interface. It functions as a **self-hosted downloader**, running a local Python server to handle download requests from a companion **Chrome extension**. This setup ensures you can **download videos locally using a Python server**, giving you full control over the process.

The core of this downloader is `yt-dlp`, a feature-rich fork of youtube-dl, combined with `ffmpeg` for processing video and audio streams.

![YouTube Downloader Interface](https://github.com/CosmiX-6/youtube-downloader-yt-dlp-local/blob/main/assets/demo.png)

## Features

-   **One-Click Downloads**: Adds a "Download with yt-dlp" button to the YouTube interface for easy **offline video download**.
-   **Self-Hosted and Private**: No need to rely on third-party websites. All downloads are handled by your own **self-hosted downloader**.
-   **High-Quality Downloads**: Uses **yt-dlp** and **ffmpeg** to download the best available MP4 video and audio by default.
-   **Browser Integration**: A simple **Chrome extension** that communicates with the local server.
-   **Desktop Notifications**: Get notified when a download starts.
-   **Automated Windows Setup**: Includes a simple setup script to install all dependencies, including **ffmpeg**.

## How It Works

The system is a classic client-server application designed for one purpose: to **download videos locally using a Python server**.

1.  **Local Python Server**: A lightweight HTTP server that listens for requests from the browser extension. When it receives a request with a YouTube video ID, it invokes **yt-dlp** to download the video to a local directory.
2.  **Chrome Extension**: A simple extension that injects a download button onto YouTube watch pages. When clicked, it sends the video ID to the local server to initiate the **offline video download**.

This architecture ensures that your download process is private and efficient, running entirely on your local machine.

## Prerequisites

-   **Windows Operating System**
-   **Python 3**: Required to run the server.
-   **FFmpeg**: Required by `yt-dlp` to merge video and audio files. The setup script handles this for you.

## Setup and Installation

Follow these steps to get the **YouTube downloader** up and running:

1.  **Download the Project**: Clone this repository or download it as a ZIP file and extract it.

2.  **Run the Installer**: Navigate to the `setup` directory and run `install.bat`. A menu will appear:

    ```
    ========================================
        yt-dlp Server Setup - Launcher
    ========================================

    1. Install yt-dlp, FFmpeg, extension
    2. Run yt-dlp server
    ```

3.  **Install Dependencies**: Choose option `1`. The script will automatically install `yt-dlp`, `plyer`, and **ffmpeg**.

4.  **Install the Chrome Extension**: After installation, the script provides instructions to load the unpacked extension from the `browser-extension` folder.

## Usage

There are two ways to run the server:

### 1. Using the Setup Script (Recommended)

Navigate to the `setup` directory and run `install.bat`, then select option `2`.

### 2. Using the Command Line (CLI)

If you prefer, you can run the server directly from the project's root directory:

```bash
# Navigate to the server directory
cd server

# Run the python server
python yt_dlp_server.py
```

Once the server is running, open a YouTube video. The "Download with yt-dlp" button will appear, allowing you to start your **offline video download**.

## Configuration

You can customize the download behavior by editing `server/yt_dlp_server.py`:

-   **Download Directory**: Change the `DOWNLOAD_DIR` variable.
-   **Download Quality**: Modify the `YT_DLP_CMD` list to change the **yt-dlp** arguments.

## License

This project is open-source and available under the [MIT License](LICENSE).

