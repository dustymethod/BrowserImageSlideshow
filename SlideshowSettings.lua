--[=====[ 

https://github.com/dustymethod/BrowserImageSlideshow
https://obsproject.com/forum/resources/browser-image-slideshow.852/

--]=====]

obs = obslua

mode = 0
slideDuration = 3800
defaultSlideDuration = 4000
minSlideDuration = 1000
maxSlideDuration = 100000
startWithAutoplay = true
browserSourceName = "Browser"
local mode_options = {"Random Order", "Alphabetical Order", "Alphabetical order, start on random"}

HK_PAUSE = obs.OBS_INVALID_HOTKEY_ID
HK_RESUME = obs.OBS_INVALID_HOTKEY_ID
HK_NEXT = obs.OBS_INVALID_HOTKEY_ID
HK_PREV = obs.OBS_INVALID_HOTKEY_ID
HK_TOGGLE_VISIBLE = obs.OBS_INVALID_HOTKEY_ID
HK_TOGGLE_PAUSE = obs.OBS_INVALID_HOTKEY_ID
HK_RESTART = obs.OBS_INVALID_HOTKEY_ID
HK_REFRESH = obs.OBS_INVALID_HOTKEY_ID

-- keycodes (for use with browser)
local KC_PAUSE = 49 --1
local KC_RESUME = 50 --2
local KC_NEXT = 51 --3
local KC_PREV = 52 --4
local KC_TOGGLE_VISIBLE = 53 --5
local KC_TOGGLE_PAUSE = 54 --6
local KC_RESTART = 55 --7
local KC_REFRESH = 56 --8

function script_description()
    return "Browser Image Slideshow\n\n" ..
    "https://obsproject.com/forum/resources/browser-image-slideshow.852/\n\n" ..
    "Press the refresh button after changing settings, or adding/removing images. This will update the slideshow and refresh the browser source."
end

function script_properties()
    props = obs.obs_properties_create()
    
    local list = obs.obs_properties_add_list(props, "mode", "Mode:", obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_INT)
    for i,v in ipairs(mode_options) do
        obs.obs_property_list_add_int(list, v, i-1)
    end
    
    obs.obs_properties_add_int(props, "slideDuration", "Slide duration (ms):", minSlideDuration, maxSlideDuration, 500)
    obs.obs_properties_add_bool(props, "startWithAutoplay", "Autoplay: automatically play slides\n (turn off for manual control)")
    obs.obs_properties_add_bool(props, "stopOnLastImage", "Stop slideshow on last image")
    obs.obs_properties_add_text(props, "browserSourceName", "Browser source name:\n(for use with hotkeys)", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_button(props, "refreshButton", "Refresh", refresh_source)
    return props
end

function pause_slideshow(key_pressed)
    send_hotkey_to_browser(KC_PAUSE, key_pressed)
end

function resume_slideshow(key_pressed)
    send_hotkey_to_browser(KC_RESUME, key_pressed)
end

function next_slide(key_pressed)
    send_hotkey_to_browser(KC_NEXT, key_pressed)
end
    
function previous_slide(key_pressed)
    send_hotkey_to_browser(KC_PREV, key_pressed)
end

function toggle_visibility(key_pressed)
    send_hotkey_to_browser(KC_TOGGLE_VISIBLE, key_pressed)
end

function toggle_pause(key_pressed)
    send_hotkey_to_browser(KC_TOGGLE_PAUSE, key_pressed)
end

function restart_slideshow(key_pressed)
    send_hotkey_to_browser(KC_RESTART, key_pressed)
end

function refresh_slideshow(key_pressed)
    if key_pressed then
        return
    end
    
    refresh_source()
end

function refresh_source()
    -- update images
    update_image_list(script_path() .. 'images/')
    
    -- refresh browser source. uses exeldro's method - https://github.com/exeldro/obs-lua/blob/master/refresh-browsers.lua
    local source = obs.obs_get_source_by_name(browserSourceName)
    local settings = obs.obs_source_get_settings(source)
    
    local fps = obs.obs_data_get_int(settings, "fps")
    if fps % 2 == 0 then
        obs.obs_data_set_int(settings, "fps", fps + 1)
    else
        obs.obs_data_set_int(settings, "fps", fps - 1)
    end
    obs.obs_source_update(source, settings)
    obs.obs_source_release(source)
end

function getUniqueName(name)
    return script_path() .. name
end
    
-- called when script is loaded
function script_load(settings)
    obs.obs_data_set_default_int(settings, "slideDuration", defaultSlideDuration)
    obs.obs_data_set_default_bool(settings, "startWithAutoplay", true)
    obs.obs_data_set_default_string(settings, "browserSourceName", "Browser")
    update_image_list(script_path() .. 'images/')
    
    local hotkey_tag = " [Slideshow]"
    
    local hotkey_save_array = obs.obs_data_get_array(settings, "HK_PAUSE")
    HK_PAUSE = obs.obs_hotkey_register_frontend(getUniqueName("HK_PAUSE"), "Pause" .. hotkey_tag, pause_slideshow)
    obs.obs_hotkey_load(HK_PAUSE, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_RESUME = obs.obs_hotkey_register_frontend(getUniqueName("HK_RESUME"), "Resume" .. hotkey_tag, resume_slideshow)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_RESUME")
    obs.obs_hotkey_load(HK_RESUME, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_NEXT = obs.obs_hotkey_register_frontend(getUniqueName("HK_NEXT"), "Next slide" .. hotkey_tag, next_slide)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_NEXT")
    obs.obs_hotkey_load(HK_NEXT, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_PREV = obs.obs_hotkey_register_frontend(getUniqueName("HK_PREV"), "Previous slide" .. hotkey_tag, previous_slide)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_PREV")
    obs.obs_hotkey_load(HK_PREV, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_TOGGLE_VISIBLE = obs.obs_hotkey_register_frontend(getUniqueName("HK_TOGGLE_VISIBLE"), "Toggle Visibility" .. hotkey_tag, toggle_visibility)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_TOGGLE_VISIBLE")
    obs.obs_hotkey_load(HK_TOGGLE_VISIBLE, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_TOGGLE_PAUSE = obs.obs_hotkey_register_frontend(getUniqueName("HK_TOGGLE_PAUSE"), "Toggle Pause/Resume" .. hotkey_tag, toggle_pause)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_TOGGLE_PAUSE")
    obs.obs_hotkey_load(HK_TOGGLE_PAUSE, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_RESTART = obs.obs_hotkey_register_frontend(getUniqueName("HK_RESTART"), "Restart" .. hotkey_tag, restart_slideshow)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_RESTART")
    obs.obs_hotkey_load(HK_RESTART, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    HK_REFRESH = obs.obs_hotkey_register_frontend(getUniqueName("HK_REFRESH"), "Refresh source" .. hotkey_tag, refresh_slideshow)
    hotkey_save_array = obs.obs_data_get_array(settings, "HK_REFRESH")
    obs.obs_hotkey_load(HK_REFRESH, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

-- called when script settings change
function script_update(settings)
    mode = obs.obs_data_get_int(settings, "mode")
    slideDuration = obs.obs_data_get_int(settings, "slideDuration")
    stopOnLastImage = obs.obs_data_get_bool(settings, "stopOnLastImage")
    startWithAutoplay = obs.obs_data_get_bool(settings, "startWithAutoplay")
    browserSourceName = obs.obs_data_get_string(settings, "browserSourceName")
    
    local output = assert(io.open(script_path() .. 'settings.js', "w"))
    output:write('let mode = '.. mode .. ';\n')
    output:write('let slideDuration = '.. slideDuration .. ';\n')
    if stopOnLastImage == true then
        output:write('let stopOnLastImage = true;\n')
    else
        output:write('let stopOnLastImage = false;\n')
    end

    if startWithAutoplay == true then
        output:write('let startWithAutoplay = true;\n')
    else
        output:write('let startWithAutoplay = false;\n')
    end
    
    output:close()
    -- log_slideshow_info()
end

function script_save(settings)
    local hotkey_save_array = obs.obs_hotkey_save(HK_PAUSE)
    obs.obs_data_set_array(settings, "HK_PAUSE", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_RESUME)
    obs.obs_data_set_array(settings, "HK_RESUME", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_NEXT)
    obs.obs_data_set_array(settings, "HK_NEXT", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_PREV)
    obs.obs_data_set_array(settings, "HK_PREV", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_TOGGLE_VISIBLE)
    obs.obs_data_set_array(settings, "HK_TOGGLE_VISIBLE", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_TOGGLE_PAUSE)
    obs.obs_data_set_array(settings, "HK_TOGGLE_PAUSE", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_RESTART)
    obs.obs_data_set_array(settings, "HK_RESTART", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
    
    hotkey_save_array = obs.obs_hotkey_save(HK_REFRESH)
    obs.obs_data_set_array(settings, "HK_REFRESH", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

function send_hotkey_to_browser(keycode, key_pressed)
    if key_pressed then -- only send on keyup
        return
    end
    
    local source = obs.obs_get_source_by_name(browserSourceName)
    if source == nil then 
        print("Browser source \"" .. browserSourceName .. "\" not found. Be sure to enter the correct source's name in the lua script.")
        return
    end

    --local vk = obs.obs_key_to_virtual_key(keycode)
    local vk =  keycode
    local event = obs.obs_key_event()
    event.native_vkey = vk
    --event.native_scancode = vk
    event.text = ""
    obs.obs_source_send_key_click(source, event, key_pressed)
    obs.obs_source_release(source)
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
    end
    
    files:close()
    output:write('`')
    output:close()
end

function log_slideshow_info()
    print("Slideshow loaded. \n" ..
    "source name: \"" .. browserSourceName .. 
    "\" | mode: ".. mode_options[mode+1] ..
    " | slide duration: ".. slideDuration ..
    "ms | loop: " .. tostring(not(stopOnLastImage)) ..
    " | autoplay: " .. tostring(startWithAutoplay))
end
