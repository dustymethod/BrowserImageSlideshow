BrowserImageSlideshow
https://github.com/dustymethod/BrowserImageSlideshow
Discussion & support: https://obsproject.com/forum/threads/browser-image-slideshow.110157/

A slideshow that can be added to OBS as a browser source.
    - Plays images in random or alphabetical order, or manually via hotkeys in OBS
    - Displays each image exactly once per loop
    - local, works offline
Useful for slideshows that may exceed 250mb uncompressed limit in OBS's current built-in slideshow

> Setup
0. Download the latest release https://github.com/dustymethod/BrowserImageSlideshow/releases
1. Add browser source in OBS:
    + Add Source > Browser
    - Choose local file "BrowserImageSlideshow.html"
    - Delete Custom CSS
    - Enable "Shutdown source when not visible" and "Refresh browser when scene becomes active" options
2. Place your slideshow images in the "images" folder (ex. png, jpg, gif)
3. Add lua script (optional)
    - OBS > Tools > Scripts > Add (+) SlideshowSettings.lua
    - adjust settings, and enter name of slideshow browser source (if using hotkeys)
4. Update slideshow & list of images
    This can be done 2 different ways, and must be done whenever images are added/removed/renamed, or slideshow settings are changed
    
    A) With Lua script in OBS:
    - Press the Refresh button in the script's settings, or press the Refresh hotkey

    B) Without Lua:
    - Run RefreshImagesW.cmd or RefreshImages.sh to update the list of images (they do the same thing)
    - Refresh the browser source by toggling its visibility from the Sources dock in OBS
    - settings can be adjusted by opening settings.js in a text editor
5. *** Repeat step 4 whenever you add/remove/rename images or update the settings! ***

> settings.js
    mode:
        0: Random order (default)
        1: Alphabetical order
        2: Alphabetical order (start on random image)
    slideDuration: duration in milliseconds (default 4000)
    loopSlideshow: if true, the slideshow will repeat. in Random order mode, images will be reshuffled. (default true)
    startWithAutoplay: if true, the slideshow will start playing automatically. untick this option if you wish to control slides manually via hotkeys.
        autoplaying/paused can be toggled with hotkeys, regardless if this option is enabled or not

> Additional Lua Settings
    Browser source name: this tells the lua script which browser source to send hotkey events to. you can ignore this setting if not using hotkeys

> Hotkeys - Requires lua script (see step 3)
    Pause: pause playback
    Resume: resume playback (if autoplay setting is off, this will still enable autoplay)
    Next: show the next slide
    Previous: show the previous slide
    Toggle visible: hide/show slideshow without pausing/restarting
    Toggle pause: same as pause/resume, but on a single hotkey
    Restart: restart the slideshow without checking for new images or settings
    Refresh: refresh browser source & restart slideshow. changes to images & settings will be reflected

> Notes & tips
    - Save slideshow somewhere that doesn't require admin permissions, such as in your Documents, and not in the default plugins folder
    - Filenames with uncommon characters may not display
    - Images in subfolders within the "images" folder will not be shown
    - RefreshImages.sh and RefreshImagesW.cmd do the same thing; make a list of files within the images folder. depending on your pc, you may be able to run one, but not the other
    - This slideshow & its scripts write to settings.js and images/images.js
    - EXIF data is ignored; images taken with a camera may not appear rotated correctly
    - This resource has only been tested on Windows. I have not done extensive testing
    - if using multiple slideshows, copy the entire slideshow folder, rathern than individual scripts, and add to OBS.

This script uses compressed jquery
https://jquery.com/

> Issues
    - because of the way script(s) write to a file, a harmless command window may pop up briefly when the script is run. Haven't found a way to suppress this yet.
