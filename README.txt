BrowserImageSlideshow v1.3
https://github.com/dustymethod/BrowserImageSlideshow
Discussion & support: https://obsproject.com/forum/threads/browser-image-slideshow.110157/

A local browser source that plays images in random or alphabetical order.
Displays each image exactly once per loop.
Useful for slideshows that may exceed OBS's slideshow's 250mb ram limit. Works offline.

settings.js (open in any text editor. ex right click > Open with > Notepad)
    mode:
        0: Random order (default)
        1: Alphabetical order
        2: Alphabetical order (start on random image)
    slideDuration: duration in milliseconds (default 4000)
    stopOnLastImage: if true, the slideshow will not repeat. (default false)
    

Setup
0. Download the zipped files from github or the releases page
    - save & unzip somewhere in your Documents folder (not in obs plugins folder)
1. Add a browser source in OBS:
    - Add Source > Browser
    - Choose local file "BrowserImageSlideshow.html"
    - Remove Custom CSS
    - Enable "Shutdown source when not visible" and "Refresh browser when scene becomes active" options.
2. Place your slideshow images in the "images" folder (ex. jpg, png, gif)
3. (Optional) Add the lua script:
    - in OBS Studio: Tools > Scripts
    - Add RefreshImagesLua.lua, select the script to view settings.
    - this is purely an alternative to using RefreshImagesW.cmd or RefreshImages.sh in step 4
4. Refreshing images/settings
    - This must be done whenever images are added/removed/renamed, or when settings are updated.
    - Run RefreshImagesW.cmd (windows) or RefreshImages.sh (linux) by double-clicking it.
    - (optional) Or, if using lua script: select RefreshImagesLua.lua & press Reload Scripts button next to +-
    - Finally, refresh the source in OBS by toggling its visibility
5. *** Repeat step 4 whenever you add/remove/rename images or update the settings! ***


Notes
    - Adding RefreshImageLua.lua to OBS Studio is optional. If not using lua, refreshing images & settings can be done
    by running RefreshImages.sh or RefreshImagesW.cmd
    - Updating settings via the lua script will overwrite settings.js.
    - The optional lua script may not work with OBS on Linux; please use RefreshImages.sh instead.
    - Filenames with uncommon characters may not display
    - EXIF data is ignored; images taken with a camera may not appear rotated correctly
    - RefreshImages: these scripts will write the names of all images to a text file, which is used by the browser source.
    - This resource has only been tested on Windows. I have not done extensive testing
    - RefreshImages.sh and RefreshImagesW.cmd do the same thing. one was added later because of compatibility issues
    
Issues
    - because of the way script(s) write to a file, a harmless command window may pop up briefly when the script is run.
    Haven't found a way to suppress this yet.
