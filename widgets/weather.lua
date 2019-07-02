--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:48:54
-- @Changes: 
--      - newly written
--      - ...
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
    return markup.fontfg(beautiful.font_name .. dpi(size), color, text)
end

module.gen_wibar_widget = function(color, city_id)
    local weather_icon = util.owf_ico(color)
    local weather_widget = lain.widget.weather(
                               {
            city_id = city_id,
            notification_preset = {
                font = beautiful.font_name .. dpi(10),
                fg = beautiful.fg_normal,
                bg = beautiful.bg_normal
            },
            weather_na_markup = markup.fontfg(beautiful.font, color, "N/A"),
            settings = function()
                descr = weather_now["weather"][1]["description"]:lower()
                units = math.floor(weather_now["main"]["temp"])
                widget:set_markup(markup.fontfg(beautiful.font, color, descr ..
                                                    " @ " .. units .. "°C"))
                weather_icon:set_markup(util.owf_markup(color, weather_now))
            end
        })
    beautiful.weather = weather_widget

    return util.create_wibar_widget(color, weather_icon, weather_widget)
end

module.gen_desktop_widget = function(color, city_id)
    local weather_icon = wibox.widget.textbox()
    local weather_temp = wibox.widget.textbox()
    local weather_temp_min = wibox.widget.textbox()
    local weather_temp_max = wibox.widget.textbox()
    local weather_descr = wibox.widget.textbox()
    local weather_unit = wibox.widget.textbox(
                             markup_color_size(42, color, "°C"))

    local widget = lain.widget.weather({
        city_id = city_id,
        weather_na_markup = markup.fontfg(beautiful.font, color, "N/A "),
        settings = function()
            descr = weather_now["weather"][1]["description"]:lower()
            temp = math.floor(weather_now["main"]["temp"])
            temp_min = math.floor(weather_now["main"]["temp_min"])
            temp_max = math.floor(weather_now["main"]["temp_max"])

            weather_icon:set_markup(util.owf_markup(color, weather_now, dpi(55)))
            weather_temp:set_markup(markup_color_size(30, color, temp))
            weather_temp_min:set_markup(markup_color_size(8, color,
                                                          temp_min .. ' - '))
            weather_temp_max:set_markup(markup_color_size(8, color, temp_max))
            weather_descr:set_markup(markup_color_size(14, color, descr))
        end
    })

    beautiful.desktop_weather = widget

    weather_temp.align = "center"
    weather_descr.align = "center"
    weather_descr.forced_width = dpi(280)

    local weather_box = wibox.widget{
        {
            {
                weather_icon,
                nil,
                {
                    {
                        weather_temp,
                        {
                            nil,
                            {
                                weather_temp_min,
                                weather_temp_max,
                                spaceing = dpi(5),
                                layout = wibox.layout.fixed.horizontal
                            },
                            nil,
                            expand = 'outside',
                            layout = wibox.layout.align.horizontal
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    weather_unit,
                    spaceing = dpi(10),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.align.horizontal
            },
            weather_descr,
            spaceing = dpi(15),
            layout = wibox.layout.fixed.vertical
        },
        margins = dpi(50),
        color = "#FF000000",
        widget = wibox.container.margin

    }

    return wibox.widget{
        nil,
        {nil, weather_box, nil, expand = "none", layout = wibox.layout.align.vertical},
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
end

-- [ return module objects ] ---------------------------------------------------
return module
