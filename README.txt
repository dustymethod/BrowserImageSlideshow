BrowserImageSlideshow v1
https://github.com/dustymethod/BrowserImageSlideshow

A local browser source for OBS that plays images in random or alphabetical order. Has no image count limit.

Modes (settings.js):
    0: random order (default). Displays each image exactly once per loop.
    1: Alphabetical order
    2: Alphabetical order (start at random image)

0. Download: click "Clone or download" from the github page, choose "Download ZIP", and unzip the files.
1. Place your images in the "images" folder. jpg, png, gifs all work.
2. Run the RefreshImages.sh script to refresh the list of images.
    - *** This must be run whenever images are added or renamed. ***
    - This script saves a list of all images in the folder in "images.js"
    - After adding images, the source can be refreshed by toggling its visibility
3. In OBS Studio or Streamlabs OBS:
    - Add Source > Browser
    - Add local file "BrowserImageSlideshow.html"
    - Remove Custom CSS
    - Check "Shutdown source when not visible" and "Refresh browser when scene becomes active"
4. *** Don't forget to run RefreshImages whenever you add or rename images! ***

Notes
    - settings.js can be opened & edited in notepad. (includes slide duration & mode settings)    
    - filenames with uncommon characters may not display
    - has only been tested in Windows