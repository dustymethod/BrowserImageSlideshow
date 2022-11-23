--[=====[ 

https://github.com/dustymethod/BrowserImageSlideshow
https://obsproject.com/forum/resources/browser-image-slideshow.852/

--]=====]

obs = obslua

mode = 0
slideDuration = 3800
imageCount = 0
defaultSlideDuration = 4000
minSlideDuration = 1000
maxSlideDuration = 100000

function script_description()
	return "Lua script for the BrowserImageSlideshow. Updates the list of images in images/images.js, and overwrites the settings in settings.js. See README for full details. " ..
    "Runs once automatically when OBS is launched. \n\n" ..

    "*** After changing the settings below, the script & browser source must be reloaded for changes to take effect: *** \n"..
    "1. Reload script: press the Reload Scripts button (next to Add/Remove scripts).\n"..
    "2. Refresh browser source: toggle the source's visiblity off and on\n"..
    
    "\nModes: \n" ..
    "[0]: Random order\n" ..
    "[1]: Alphabetical order\n" ..
    "[2]: Alphabetical order (start at random image)\n\n"..

    "https://obsproject.com/forum/resources/browser-image-slideshow.852/"

end

function script_properties()
    props = obs.obs_properties_create()
    obs.obs_properties_add_int(props, "mode", "Mode:", 0, 2, 1)
    obs.obs_properties_add_int(props, "slideDuration", "Slide duration (ms):", minSlideDuration, maxSlideDuration, 500)
    obs.obs_properties_add_bool(props, "stopOnLastImage", "Stop slideshow on last image?")
    return props
end

-- called when script is loaded
function script_load(settings)
    obs.obs_data_set_default_int(settings, "slideDuration", defaultSlideDuration)
    update_image_list(script_path() .. 'images/')
end

-- called when script settings change
function script_update(settings)
    mode = obs.obs_data_get_int(settings, "mode")
    slideDuration = obs.obs_data_get_int(settings, "slideDuration")
    stopOnLastImage = obs.obs_data_get_bool(settings, "stopOnLastImage")
    update_slideshow_settings()
end

-- write settings to js file
function update_slideshow_settings()
    local output = assert(io.open(script_path() .. 'settings.js', "w"))
    
    output:write('let mode = '.. mode .. ';\n')
    output:write('let slideDuration = '.. slideDuration .. ';\n')
    if stopOnLastImage == true then
        output:write('let stopOnLastImage = true;\n')
    else
        output:write('let stopOnLastImage = false;\n')
    end
    output:close()
    
    log_slideshow_info()
end

-- write list of images to js file
function update_image_list(dir)
    local output = assert(io.open(script_path() .. 'images/images.js', "w"))
    local files = assert(io.popen('dir "'..dir..'" /b'))
    output:write('let imageNamesStr=`\n')
    imageCount = 0
    
    for line in files:lines() do
        output:write(line .. "\n")
        imageCount = imageCount + 1
        --print(line)
    end
    
    files:close()
    output:write('`')
    output:close()
end

function log_slideshow_info()
    print("BrowserImageSlideshow updated. \n" .. "Files detected: ".. imageCount .." | mode: ".. mode .." | duration: ".. slideDuration .. "ms | loop: " .. tostring(not(stopOnLastImage)))
end
