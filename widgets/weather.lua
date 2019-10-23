--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- weather widgets
-- [ changelog ] ---------------------------------------------------------------
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
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ function definitions ] ----------------------------------------------------
local markup_color_size = function(size, color, text)
    return markup.fontfg(beautiful.font_name .. size,  color, text)
end

module.gen_wibar_widget = function(city_id)
    local weather_icon = util.owf_ico(beautiful.widget_colors.weather)
    local weather_widget = lain.widget.weather(
                               {
            city_id = city_id,
            weather_na_markup = markup.fontfg(beautiful.font,
                                              beautiful.widget_colors.weather,
                                              "N/A"),
            settings = function()
                descr = weather_now["weather"][1]["description"]:lower()
                units = math.floor(weather_now["main"]["temp"])
                widget:set_markup(markup.fontfg(beautiful.font,
                                                beautiful.widget_colors.weather,
                                                descr .. " @ " .. units .. "°C"))
                weather_icon:set_markup(util.owf_markup(
                                            beautiful.widget_colors.weather,
                                            weather_now))
            end,
            notification_preset = {
                fg = beautiful.fg_normal,
                bg = beautiful.bg_normal
            }
        })

    return util.create_wibar_widget(beautiful.widget_colors.weather,
                                    weather_icon, weather_widget),
           weather_widget
end

module.gen_desktop_widget = function(city_id)
    local font_size = beautiful.desktop_widgets_weather_font_size

    local font_size_temp = 0.8 * font_size
    local font_size_range = 0.2 * font_size
    local font_size_descr = 0.3 * font_size

    local weather_icon = wibox.widget.textbox()
    local weather_temp = wibox.widget.textbox()
    local weather_temp_min = wibox.widget.textbox()
    local weather_temp_max = wibox.widget.textbox()
    local weather_descr = wibox.widget.textbox()
    local weather_unit = wibox.widget.textbox(
                             markup_color_size(font_size, beautiful.fg_normal, "°C"))

    local weather_widget = lain.widget.weather(
                               {
            city_id = city_id,
            weather_na_markup = markup.fontfg(beautiful.font,
                                              beautiful.fg_normal, "N/A "),
            settings = function()
                descr = weather_now["weather"][1]["description"]:lower()
                temp = math.floor(weather_now["main"]["temp"])
                temp_min = math.floor(weather_now["main"]["temp_min"])
                temp_max = math.floor(weather_now["main"]["temp_max"])

                weather_icon:set_markup(util.owf_markup(beautiful.fg_normal,
                                                        weather_now, font_size))
                weather_temp:set_markup(markup_color_size(font_size_temp,
                                                          beautiful.fg_normal,
                                                          temp))
                weather_temp_min:set_markup(
                    markup_color_size(font_size_range, beautiful.fg_normal, temp_min .. ' - '))
                weather_temp_max:set_markup(
                    markup_color_size(font_size_range, beautiful.fg_normal, temp_max))
                weather_descr:set_markup(
                    markup_color_size(font_size_descr, beautiful.fg_normal, descr))
            end
        })

    weather_temp.align = "center"
    weather_descr.align = "center"
    weather_unit.align = "center"

    local weather_box = wibox.widget{
        {
            nil,
            {
                weather_icon,
                {
                    {
                        weather_temp,
                        {
                            nil,
                            {
                                weather_temp_min,
                                weather_temp_max,
                                layout = wibox.layout.fixed.horizontal
                            },
                            nil,
                            expand = "outside",
                            layout = wibox.layout.align.horizontal
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    weather_unit,
                    layout = wibox.layout.fixed.horizontal
                },
                spacing = dpi(15),
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

    return wibox.widget{
        nil,
        {
            nil,
            weather_box,
            nil,
            expand = "none",
            layout = wibox.layout.align.vertical
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    }, weather_widget
end

-- [ return module objects ] ---------------------------------------------------
return module
