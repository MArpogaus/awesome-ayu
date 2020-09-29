--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- weather widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-29 13:32:08
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
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local default_timeout = 1800

-- [ local functions ] ---------------------------------------------------------
local function markup_color_size(size, color, text)
    return util.fontfg(beautiful.font_name .. size, color, text)
end

local function weather_widget_container(args)
    -- define widgets
    local font_size = args.font_size
    local color = args.color
    local spacing = args.spacing

    local weather_icon = args.weather_icon
    local weather_widget = args.weather_widget
    local weather_temp_min = args.weather_temp_min
    local weather_temp_max = args.weather_temp_max
    local weather_descr = args.weather_descr
    local weather_unit = wibox.widget.textbox(
                             markup_color_size(font_size, color, '°C')
                         )

    weather_widget.align = 'center'
    weather_descr.align = 'center'
    weather_unit.align = 'center'

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
        spacing = spacing,
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

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious_contrib.openweather)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local city_id, app_id = wargs.city_id, wargs.app_id

    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.weather},
        widgets = {
            icon = {
                widget = util.owf_ico(beautiful.widget_colors.weather),
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    local sunrise = args['{sunrise}']
                    local sunset = args['{sunset}']

                    return util.owf_markup(
                               beautiful.widget_colors.weather, weather,
                               sunrise, sunset
                           )
                end
            },
            widget = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, beautiful.widget_colors.weather,
                               args['{temp c}'] .. '°C'
                           )
                end
            }
        }
    }
end
widget_defs.desktop = function(wargs)
    local city_id, app_id = wargs.city_id, wargs.app_id

    local font_size = beautiful.desktop_widgets_weather_font_size

    local font_size_temp = 0.8 * font_size
    local font_size_range = 0.2 * font_size
    local font_size_descr = 0.3 * font_size

    return {
        default_timeout = default_timeout,
        widget_container = weather_widget_container,
        container_args = {
            font_size = font_size,
            color = beautiful.widget_colors.desktop.weather.fg,
            spacing = font_size_descr / 2
        },
        widgets = {
            weather_icon = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    local sunrise = args['{sunrise}']
                    local sunset = args['{sunset}']

                    return util.owf_markup(
                               beautiful.widget_colors.desktop.weather.fg,
                               weather, sunrise, sunset, font_size
                           )
                end
            },
            weather_widget = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local temp = args['{temp c}']
                    return markup_color_size(
                               font_size_temp,
                               beautiful.widget_colors.desktop.weather.fg, temp
                           )
                end
            },
            weather_temp_min = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local temp_min = math.floor(
                                         tonumber(args['{temp min c}']) or 0
                                     )
                    return markup_color_size(
                               font_size_range,
                               beautiful.widget_colors.desktop.weather.fg,
                               temp_min .. ' / '
                           )
                end
            },
            weather_temp_max = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local temp_max = math.ceil(
                                         tonumber(args['{temp max c}']) or 0
                                     )
                    return markup_color_size(
                               font_size_range,
                               beautiful.widget_colors.desktop.weather.fg,
                               temp_max
                           )
                end
            },
            weather_descr = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    return markup_color_size(
                               font_size_descr,
                               beautiful.widget_colors.desktop.weather.fg,
                               weather
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
