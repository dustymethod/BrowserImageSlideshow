BrowserImageSlideshow
https://github.com/dustymethod/BrowserImageSlideshow
Discussion & support: https://obsproject.com/forum/threads/browser-image-slideshow.110157/

A slideshow that can be added to OBS as a local browser source.
    - Random or alphabetical order
    - Play slides automatically or via OBS hotkeys
    - Displays each image exactly once per loop
    - Uses HTML, JavaScript, Lua. Works offline
Useful for slideshows that may exceed the 250mb uncompressed limit in older versions of OBS's built-in slideshow (versions older than 30.1)

> SETUP INSTRUCTIONS
0. Download the latest release https://github.com/dustymethod/BrowserImageSlideshow/releases
    - Download to a location that doesn't require admin permissions, ex. Documents, and not in the default plugins folder
1. Add browser source in OBS:
    + Add Source > Browser
    - Choose local file "BrowserImageSlideshow.html"
    - Delete Custom CSS
    - Enable "Shutdown source when not visible" and "Refresh browser when scene becomes active" options
2. Place your slideshow images in the "images" folder
3. Add lua script (needed for hotkeys, otherwise this step is optional)
    - OBS > Tools > Scripts > Add (+) SlideshowSettings.lua
    - if using hotkeys: ensure the "Browser source name" field matches the name of your slideshow browser source in OBS.
4. Update slideshow & list of images
    This can be done 2 different ways, and must be done whenever images are added/removed/renamed, or slideshow settings are changed
    
    A) With Lua script in OBS:
    - Press the Refresh button in the script's settings, or press the Refresh hotkey

    B) Without Lua:
    - Run RefreshImagesW.cmd or RefreshImages.sh to update the list of images (they do the same thing)
    - Refresh the browser source by toggling its visibility from the Sources dock in OBS
    - settings can be adjusted manually by opening settings.js in a text editor. these settings will be overwritten if using the Lua script.
    
    Repeat this step whenever you add/remove/rename images or update the settings!




> settings.js
    mode:
        0: Random order (default)
        1: Alphabetical order
        2: Alphabetical order (start on random image)
    slideDuration: duration in milliseconds (default 4000)
    loopSlideshow: if true, the slideshow will repeat. in Random order mode, images will be reshuffled. (default true)
    startWithAutoplay: if true, the slideshow will start playing automatically. untick this option if you wish to control slides manually via hotkeys.
        autoplay/pause can be toggled with hotkeys, regardless if this option is enabled or not


> Hotkeys - Requires lua script (see step 3)
    Pause: pause playback
    Resume: resume playback (if autoplay setting is off, autoplay will now be enabled)
    Next: show the next slide
    Previous: show the previous slide
    Toggle visible: hide/show slideshow without pausing/restarting
    Toggle pause: same as pause/resume, but on a single hotkey
    Restart: restart the slideshow without checking for new images or settings
    Refresh: refresh browser source & restart slideshow. changes to images & settings will be reflected

> Hotkey Notes
    - Browser source name (lua): this tells the lua script which browser source to send hotkey events to. you can ignore this setting if not using hotkeys
    - in OBS's hotkey settings, this script's hotkey names are shown with [Slideshow] at the end. Hotkeys listed under "Image Slide Show" are for OBS's own built-in slideshow.

> Notes & tips
    - Filenames with uncommon characters may not display
    - Images in subfolders within the "images" folder will not be shown
    - RefreshImages.sh and RefreshImagesW.cmd do the same thing; make a list of files within the images folder. depending on your environment, you may be able to run one, but not the other
    - This slideshow & its scripts write to settings.js and images/images.js
    - EXIF data is ignored; images taken with a camera may not appear rotated correctly
    - This resource has only been tested on Windows. I have not done extensive testing

This script uses compressed jquery
https://jquery.com/

> Issues
    - because of the way script(s) write to a file, a harmless command window may pop up briefly when the script is run. Haven't found a way to suppress this yet.
