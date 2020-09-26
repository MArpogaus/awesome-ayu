--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- weather widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 18:45:27
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

-- [ local functions ] ---------------------------------------------------------
local markup_color_size = function(size, color, text)
    return util.fontfg(beautiful.font_name .. size, color, text)
end

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(city_id, app_id)
    local weather_icon = util.owf_ico(beautiful.widget_colors.weather)
    local weather_widget = wibox.widget.textbox()
    local weather_widget_formatter = function(_, args)
        local weather = args['{weather}']

        local sunrise = args['{sunrise}']
        local sunset = args['{sunset}']

        local weather_desc = args['{temp c}'] .. '°C'
        weather_icon:set_markup(util.owf_markup(
                                    beautiful.widget_colors.weather, weather,
                                    sunrise, sunset))
        return util.fontfg(beautiful.font, beautiful.widget_colors.weather,
                           weather_desc)
    end
    vicious.register(weather_widget, vicious_contrib.openweather,
                     weather_widget_formatter, 1800,
                     {city_id = city_id, app_id = app_id})

    return util.create_wibar_widget(beautiful.widget_colors.weather,
                                    weather_icon, weather_widget)
end

module.gen_desktop_widget = function(city_id, app_id)
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
                             markup_color_size(font_size, beautiful.fg_normal,
                                               '°C'))

    local weather_widget_formatter = function(_, args)
        local weather = args['{weather}']
        local temp = args['{temp c}']
        local temp_min = math.floor(tonumber(args['{temp min c}']) or 0)
        local temp_max = math.ceil(tonumber(args['{temp max c}']) or 0)

        local sunrise = args['{sunrise}']
        local sunset = args['{sunset}']

        weather_icon:set_markup(util.owf_markup(beautiful.fg_normal, weather,
                                                sunrise, sunset, font_size))
        weather_temp_min:set_markup(markup_color_size(font_size_range,
                                                      beautiful.fg_normal,
                                                      temp_min .. ' / '))
        weather_temp_max:set_markup(markup_color_size(font_size_range,
                                                      beautiful.fg_normal,
                                                      temp_max))
        weather_descr:set_markup(markup_color_size(font_size_descr,
                                                   beautiful.fg_normal, weather))
        return markup_color_size(font_size_temp, beautiful.fg_normal, temp)
    end
    vicious.register(weather_widget, vicious_contrib.openweather,
                     weather_widget_formatter, 1800,
                     {city_id = city_id, app_id = app_id})

    weather_widget.align = 'center'
    weather_descr.align = 'center'
    weather_unit.align = 'center'

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

-- [ return module object ] -----------.----------------------------------------
return module
