BrowserImageSlideshow v1.2
https://github.com/dustymethod/BrowserImageSlideshow
Discussion & support: https://obsproject.com/forum/threads/random-image-slideshow.110157/

A local browser source for OBS that plays images in random or alphabetical order.
Displays each image exactly one per loop.

Modes (settings.js)
    0: Random order
    1: Alphabetical order
    2: Alphabetical order (start at random image when source becomes visible)

Setup
0. Download: click "Clone or download" from the github page, choose "Download ZIP", and unzip the files.
    - save the zip somewhere in your Documents folder, and not in the default obs-plugins folder.
1. Add the browser source in OBS:
    - Add Source > Browser
    - Choose local file "BrowserImageSlideshow.html"
    - Remove Custom CSS
    - Enable "Shutdown source when not visible" and "Refresh browser when scene becomes active" options.
2: Add the lua script:
    - Tools > Scripts
    - Add RefreshImagesLua.lua. Select the script to view settings.
3. Place slideshow images in the "images" folder. jpg, png, gifs all work.
4. Refresh images/settings
    - This must be done whenever images are added/removed/renamed, or when settings are updated.
    - OBS > Tools > Scripts: select script & press Reload scripts button
    - Refresh the source in OBS by toggling its visibility
5. *** Repeat step 4 whenever you add/remove/rename images or update the settings. ***


Notes
    - Adding RefreshImageLua.lua to OBS is optional. if not used, the list of images needs to be updated 
    manually by running RefreshImagesW.cmd (windows) or RefreshImages.sh (linux)
    - settings.js can be opened & edited manually in any text editor. (includes slide duration & mode settings)
    - updating settings thru RefreshImagesLua.lua will overwrite settings.js
    - Filenames with uncommon characters may not display
    - OBS's slideshow currently preloads all slideshow images, and has a 250MB limit.
    This browser source doesn't preload images, and has no 250MB limit.
    
Issues
    - because of the way script(s) write to a file, a harmless command window will pop up briefly when the script is run.
    Haven't found a way to suppress this yet.
