--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- weather widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-27 23:42:19
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-12-05 19:09:52
-- @Changes: 
--      - changed min/max sperator from '-' to '/'
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:19
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-08-16 11:44:19
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 10:50:17
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local math = math

local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')
local vicious_contrib = require('vicious.contrib')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local registered_widgets = {}

local default_timeout = 1800

-- [ local functions ] ---------------------------------------------------------
local markup_color_size = function(size, color, text)
    return util.fontfg(beautiful.font_name .. size, color, text)
end

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(city_id, app_id, timeout)
    -- define widgets
    local weather_icon = util.owf_ico(beautiful.widget_colors.weather)
    local weather_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function weather_icon_formatter(_, args)
        local weather = args['{weather}']
        local sunrise = args['{sunrise}']
        local sunset = args['{sunset}']

        return util.owf_markup(
                   beautiful.widget_colors.weather, weather, sunrise, sunset
               )
    end
    local function weather_widget_formatter(_, args)
        return util.fontfg(
                   beautiful.font, beautiful.widget_colors.weather,
                   args['{temp c}'] .. '°C'
               )
    end

    -- register widgets
    vicious.register(
        weather_icon, vicious_contrib.openweather, weather_icon_formatter,
        timeout or default_timeout, {city_id = city_id, app_id = app_id}
    )
    vicious.register(
        weather_widget, vicious_contrib.openweather, weather_widget_formatter,
        timeout or default_timeout, {city_id = city_id, app_id = app_id}
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, weather_icon)
    table.insert(registered_widgets, weather_widget)

    -- return wibar widget
    return util.create_wibar_widget(
               beautiful.widget_colors.weather, weather_icon, weather_widget
           )
end

module.gen_desktop_widget = function(city_id, app_id, timeout)
    -- define widgets
    local font_size = beautiful.desktop_widgets_weather_font_size

    local font_size_temp = 0.8 * font_size
    local font_size_range = 0.2 * font_size
    local font_size_descr = 0.3 * font_size

    local weather_icon = wibox.widget.textbox()
    local weather_widget = wibox.widget.textbox()
    local weather_temp_min = wibox.widget.textbox()
    local weather_temp_max = wibox.widget.textbox()
    local weather_descr = wibox.widget.textbox()
    local weather_unit = wibox.widget.textbox(
                             markup_color_size(
                                 font_size, beautiful.fg_normal, '°C'
                             )
                         )
    weather_widget.align = 'center'
    weather_descr.align = 'center'
    weather_unit.align = 'center'

    -- define custom formatting function
    local function weather_icon_formatter(_, args)
        local weather = args['{weather}']
        local sunrise = args['{sunrise}']
        local sunset = args['{sunset}']

        return util.owf_markup(
                   beautiful.fg_normal, weather, sunrise, sunset, font_size
               )
    end
    local function weather_widget_formatter(_, args)
        local temp = args['{temp c}']
        return markup_color_size(font_size_temp, beautiful.fg_normal, temp)
    end
    local function weather_temp_min_formatter(_, args)
        local temp_min = math.floor(tonumber(args['{temp min c}']) or 0)
        return markup_color_size(
                   font_size_range, beautiful.fg_normal, temp_min .. ' / '
               )
    end
    local function weather_temp_max_formatter(_, args)
        local temp_max = math.ceil(tonumber(args['{temp max c}']) or 0)
        return
            markup_color_size(font_size_range, beautiful.fg_normal, temp_max)
    end
    local function weather_descr_formatter(_, args)
        local weather = args['{weather}']
        return markup_color_size(font_size_descr, beautiful.fg_normal, weather)
    end

    -- register widgets
    vicious.register(
        weather_icon, vicious_contrib.openweather, weather_icon_formatter,
        timeout or default_timeout, {city_id = city_id, app_id = app_id}
    )
    vicious.register(
        weather_widget, vicious_contrib.openweather, weather_widget_formatter,
        timeout or default_timeout, {city_id = city_id, app_id = app_id}
    )
    vicious.register(
        weather_temp_min, vicious_contrib.openweather,
        weather_temp_min_formatter, timeout or default_timeout,
        {city_id = city_id, app_id = app_id}
    )
    vicious.register(
        weather_temp_max, vicious_contrib.openweather,
        weather_temp_max_formatter, timeout or default_timeout,
        {city_id = city_id, app_id = app_id}
    )
    vicious.register(
        weather_descr, vicious_contrib.openweather, weather_descr_formatter,
        timeout or default_timeout, {city_id = city_id, app_id = app_id}
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, weather_icon)
    table.insert(registered_widgets, weather_widget)
    table.insert(registered_widgets, weather_temp_min)
    table.insert(registered_widgets, weather_temp_max)
    table.insert(registered_widgets, weather_descr)

    -- define widget layout
    local weather_box = wibox.widget {
        {
            nil,
            {
                weather_icon,
                {
                    {
                        weather_widget,
                        {
                            nil,
                            {
                                weather_temp_min,
                                weather_temp_max,
                                layout = wibox.layout.fixed.horizontal
                            },
                            nil,
                            expand = 'outside',
                            layout = wibox.layout.align.horizontal
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    weather_unit,
                    layout = wibox.layout.fixed.horizontal
                },
                spacing = 15,
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = 'outside',
            layout = wibox.layout.align.horizontal
        },
        weather_descr,
        spacing = font_size_descr / 2,
        layout = wibox.layout.fixed.vertical
    }

    -- return widget
    return wibox.widget {
        nil,
        {
            nil,
            weather_box,
            nil,
            expand = 'none',
            layout = wibox.layout.align.vertical
        },
        nil,
        expand = 'none',
        layout = wibox.layout.align.horizontal
    }, weather_widget
end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious_contrib.openweather)

-- [ return module object ] -----------.----------------------------------------
return module
