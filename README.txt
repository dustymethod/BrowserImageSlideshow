BrowserImageSlideshow v1
https://github.com/dustymethod/BrowserImageSlideshow

A local browser source for OBS that plays images in random or alphabetical order. Has no image count limit.

Modes (settings.js)
    0: Random order (default). Displays each image exactly once per loop.
    1: Alphabetical order
    2: Alphabetical order (start at random image)

Setup
0. Download: click "Clone or download" from the github page, choose "Download ZIP", and unzip the files.
1. In OBS Studio or Streamlabs OBS:
    - Add Source > Browser
    - Add local file "BrowserImageSlideshow.html"
    - Remove Custom CSS
    - Check "Shutdown source when not visible" and "Refresh browser when scene becomes active"
2. Place your images in the "images" folder. jpg, png, gifs all work.
3. Refresh images - This must be done whenever images are added or renamed!
    - Run RefreshImages.sh
    - Refresh the source in OBS by toggling its visibility
4. *** Repeat step 3 whenever you add or rename images, or they won't appear! ***

Notes
    - settings.js can be opened & edited in notepad. (includes slide duration & mode settings)
    - To use updated settings, refresh source by toggling visibility
    - RefreshImages.sh saves a list of all images in the images folder in "images.js"
    - Filenames with uncommon characters may not display
    
Discussion & support: https://obsproject.com/forum/threads/random-image-slideshow.110157/
