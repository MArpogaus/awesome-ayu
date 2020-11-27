--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 13:23:06
-- [ description ] -------------------------------------------------------------
-- weather widgets
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
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

local default_color = beautiful.fg_normal

local default_city_id = ''
local default_app_id = ''

-- [ local functions ] ---------------------------------------------------------
local function markup_color_size(size, color, text)
    return util.markup {
        font = beautiful.font_name .. size,
        fg_color = color,
        text = text
    }
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
    }
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious_contrib.openweather)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_color
    local city_id = warg.city_id or default_city_id
    local app_id = warg.app_id or default_app_id

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {
                widget = util.owf_ico(color),
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    local weather = args['{weather}']
                    local sunrise = args['{sunrise}']
                    local sunset = args['{sunset}']

                    return util.owf_markup(color, weather, sunrise, sunset)
                end
            },
            widget = {
                wtype = vicious_contrib.openweather,
                warg = {city_id = city_id, app_id = app_id},
                format = function(_, args)
                    return util.markup {
                        fg_color = color,
                        text = args['{temp c}'] .. '°C'
                    }
                end
            }
        }
    }
end
widget_defs.desktop = function(warg)
    local city_id = warg.city_id or default_city_id
    local app_id = warg.app_id or default_app_id

    local font_size = beautiful.desktop_widgets_weather_font_size

    local font_size_temp = 0.8 * font_size
    local font_size_range = 0.2 * font_size
    local font_size_descr = 0.3 * font_size

    return {
        default_timeout = default_timeout,
        widget_container = weather_widget_container,
        container_args = {
            font_size = font_size,
            color = beautiful.widgets.desktop.weather.fg,
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
                               beautiful.widgets.desktop.weather.fg, weather,
                               sunrise, sunset, font_size
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
                               beautiful.widgets.desktop.weather.fg, temp
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
                               beautiful.widgets.desktop.weather.fg,
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
                               beautiful.widgets.desktop.weather.fg, temp_max
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
                               beautiful.widgets.desktop.weather.fg, weather
                           )
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
