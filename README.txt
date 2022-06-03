BrowserImageSlideshow v1.2
https://github.com/dustymethod/BrowserImageSlideshow
Discussion & support: https://obsproject.com/forum/threads/browser-image-slideshow.110157/

A local browser source that plays images in random or alphabetical order.
Displays each image exactly once per loop.
Useful for slideshows that may exceed OBS's slideshow's 250mb ram limit. Works offline.

settings.js (can be opened & edited manually in any text editor)
    mode:
        0: Random order (default)
        1: Alphabetical order
        2: Alphabetical order (start on random image)
    slideDuration: duration in milliseconds (default 4000)
    stopOnLastImage: if true, the slideshow will not repeat. (default false)
    

Setup
0. Download: click "Clone or download" from the github page, choose "Download ZIP", and unzip the files.
    - save the zip somewhere in your Documents folder, and not in the default obs-plugins folder.
1. Add the browser source in OBS:
    - Add Source > Browser
    - Choose local file "BrowserImageSlideshow.html"
    - Remove Custom CSS
    - Enable "Shutdown source when not visible" and "Refresh browser when scene becomes active" options.
2. Place slideshow images in the "images" folder (ex. jpg, png, gif)
3: (Optional) Add the lua script:
    - in OBS Studio: Tools > Scripts
    - Add RefreshImagesLua.lua, select the script to view settings.
    - updating settings via lua script will overwrite settings.js.
4. Refresh images/settings
    - This must be done whenever images are added/removed/renamed, or when settings are updated.
    - if using lua script: select RefreshImagesLua.lua & press Reload scripts button
    - Or, if not using the lua script, run RefreshImagesW.cmd (windows) or RefreshImages.sh (linux) by double-clicking it.
    - Refresh the source in OBS by toggling its visibility
5. *** Repeat step 4 whenever you add/remove/rename images or update the settings. ***

Notes
    - Adding RefreshImageLua.lua to OBS Studio is optional. If not used, refreshing images & settings can still be done manually 
    by running RefreshImages.sh or RefreshImagesW.cmd
    - Filenames with uncommon characters may not display
    - EXIF data is ignored; images taken with a camera may not appear rotated correctly
    - both RefreshImages scripts will write the names of all images to a text file, which is used by the browser source.
    
Issues
    - because of the way script(s) write to a file, a harmless command window will pop up briefly when the script is run.
    Haven't found a way to suppress this yet.
