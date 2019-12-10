--[=====[ 

v1.2
https://obsproject.com/forum/resources/random-image-slideshow.852/
https://github.com/dustymethod/BrowserImageSlideshow

--]=====]

obs = obslua

mode = 0
slideDuration = 3800
imageCount = 0
defaultSlideDuration = 4000
minSlideDuration = 1000
maxSlideDuration = 100000

function script_description()
	return "Script for the slideshow browser source. Saves a list of images in images/images.js, and saves settings in settings.js. See README for full details. " ..
    "Is run automatically when OBS is launched.\n\n" ..

    "*** Whenever settings or images are updated, reload the script & refresh the browser to use updated settings/images: \n"..
    "- Reload script: press the reload button with this script selected.\n"..
    "- Refresh browser source: toggle the source's visiblity off and on\n"..
    
    "\nModes: \n" ..
    "0: Random order\n" ..
    "1: Alphabetical order\n" ..
    "2: Alphabetical order (start at random image when source becomes visible)"
end

function script_properties()
    props = obs.obs_properties_create()
    obs.obs_properties_add_int(props, "mode", "Mode:", 0, 2, 1)
    obs.obs_properties_add_int(props, "slideDuration", "Slide duration (ms):", minSlideDuration, maxSlideDuration, 500)
    return props
end

-- called when script is loaded
function script_load(settings)
    obs.obs_data_set_default_int(settings, "slideDuration", defaultSlideDuration)
    refresh_images()
end

-- called when script settings change
function script_update(settings)
    mode = obs.obs_data_get_int(settings, "mode")
    slideDuration = obs.obs_data_get_int(settings, "slideDuration")
    update_slideshow_settings()
end

-- write settings to js file
function update_slideshow_settings()
    local output = assert(io.open(script_path() .. 'settings.js', "w"))
    
    output:write('let mode = '.. mode .. ';\n')
    output:write('let slideDuration = '.. slideDuration .. ';\n')
    output:close()
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

function refresh_images()
    local list = update_image_list(script_path() .. 'images/')
    print("Refreshed images (images: ".. imageCount .." | mode: ".. mode .." | duration: ".. slideDuration .. ")")
end
