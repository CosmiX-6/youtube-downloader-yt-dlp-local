# yt-dlp Local Downloader Interface

This project provides a seamless interface to download YouTube videos using the powerful `yt-dlp` command-line tool. It works by running a local web server and a companion browser extension that adds a "Download" button directly to the YouTube video page.

![Demo Image](https://raw.githubusercontent.com/CosmiX-6/yt-dlp-local-downloader-interface/main/assets/demo.png)

## Features

- **Easy Downloads**: Adds a "Download with yt-dlp" button to the YouTube interface.
- **Local Server**: No need to rely on third-party websites. All downloads are handled by a server running on your own machine.
- **High Quality**: Downloads the best available MP4 video and audio by default.
- **Desktop Notifications**: Get notified when a download starts.
- **Automated Setup**: Includes a simple setup script for Windows to install all dependencies.

## How It Works

The system consists of two main components:

1.  **Local Python Server**: A lightweight HTTP server that listens for requests from the browser extension. When it receives a request with a YouTube video ID, it invokes `yt-dlp` to download the video to a local directory.
2.  **Browser Extension**: A simple extension that injects a download button onto YouTube watch pages. When clicked, it sends the video ID to the local server to initiate the download.

This architecture ensures that your download process is private and efficient, running entirely on your local machine.

## Prerequisites

- **Windows Operating System**
- **Python 3**: The setup script will check if Python is installed and available in your system's PATH.

## Setup and Installation

Follow these steps to get the downloader up and running:

1.  **Download the Project**: Clone this repository or download it as a ZIP file and extract it to your computer.

2.  **Run the Installer**: Navigate to the `setup` directory and run the `install.bat` script. A menu will appear:

    ```
    ========================================
        yt-dlp Server Setup - Launcher
    ========================================

    1. Install yt-dlp, FFmpeg, extension
    2. Run yt-dlp server
    ```

3.  **Install Dependencies**: 
    - Choose option `1` to start the installation process.
    - The script will automatically:
        - Install `yt-dlp` and `plyer` using pip.
        - Download and configure **FFmpeg** (required for merging video and audio) and add it to your system's PATH.

4.  **Install the Browser Extension**:
    - After the dependencies are installed, the script will provide instructions for installing the browser extension in Chrome (or any Chromium-based browser).
    - Go to `chrome://extensions/`.
    - Enable **Developer Mode**.
    - Click **"Load unpacked"** and select the `browser-extension` folder from the project directory.

## Usage

1.  **Start the Server**: Run the `install.bat` script again from the `setup` directory and choose option `2` to start the yt-dlp server. A terminal window will open, indicating that the server is running.

2.  **Download Videos**: 
    - Open a YouTube video you want to download.
    - You will see a new **"Download with yt-dlp"** button next to the like/dislike buttons.
    - Click the button. A desktop notification will confirm that the download has started.

3.  **Find Your Files**: By default, all downloaded videos are saved in your `Downloads/Youtube-Downloaded-Videos` folder.

## Configuration

You can customize the download behavior by editing the `server/yt_dlp_server.py` file:

- **Download Directory**: Change the `DOWNLOAD_DIR` variable to set a different output folder.
- **Download Quality**: Modify the `YT_DLP_CMD` list to change the `yt-dlp` arguments, such as video format and quality.

## License

This project is open-source and available under the [MIT License](LICENSE).
