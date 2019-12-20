BrowserImageSlideshow v1.2
https://github.com/dustymethod/BrowserImageSlideshow
Discussion & support: https://obsproject.com/forum/threads/browser-image-slideshow.110157/

A local browser source that plays images in random or alphabetical order.
Displays each image exactly once per loop.
Useful for slideshows that may exceed OBS's slideshow's 250mb ram limit. Works offline.

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
2. Place slideshow images in the "images" folder. jpg, png, gifs all work.
3: Add the lua script (optional):
    - in OBS Studio: Tools > Scripts
    - Add RefreshImagesLua.lua. Select the script to view settings.
4. Refresh images/settings
    - This must be done whenever images are added/removed/renamed, or when settings are updated.
    - OBS Studio > Tools > Scripts: select script & press Reload scripts button
    - Or, if not using the lua script, run RefreshImagesW.cmd (windows) or RefreshImages.sh (linux) by double-clicking it.
    - Refresh the source in OBS by toggling its visibility
5. *** Repeat step 4 whenever you add/remove/rename images or update the settings. ***

Notes
    - Adding RefreshImageLua.lua to OBS Studio is optional. If not used, refreshing images & settings can still be done manually 
    by running RefreshImagesW.cmd (windows) or RefreshImages.sh (linux).
    - settings.js can be opened & edited manually in any text editor. (includes slide duration & mode settings)
    - updating settings using RefreshImagesLua.lua in OBS Studio will overwrite settings.js
    - Filenames with uncommon characters may not display
    
Issues
    - because of the way script(s) write to a file, a harmless command window will pop up briefly when the script is run.
    Haven't found a way to suppress this yet.
