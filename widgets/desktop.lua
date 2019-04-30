--[[ ---------------------------------------------------------------------------
     AYU Awesome WM desktop widgets

     inspired by Multicolor Awesome WM beutiful 2.0
     github.com/lcpz
--]] ---------------------------------------------------------------------------
-- [ libraries ]-----------------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")

local markup = lain.util.markup

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local util = require("themes.ayu.util")

local city_id = 2658372

local module = {}

-- [ clock ] -------------------------------------------------------------------
local deskop_clock = wibox.widget.textclock(
                         markup.fontfg(beautiful.font_name .. dpi(48),
                                       "#FFFFFF", " %H:%M "))
local deskop_clock_box = util.create_boxed_widget(deskop_clock, 500, 200,
                                                  beautiful.widget_colors
                                                      .desktop_clock)

local desktop_clock_date = wibox.widget.textclock(
                               markup.fontfg(beautiful.font_name .. dpi(18),
                                             beautiful.fg_normal, "Today is ") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.widget_colors
                                                     .desktop_day, "%A") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.fg_normal, ", ") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.widget_colors
                                                     .desktop_date, "%d. %B") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.fg_normal,
                                                 " and there is "))

local desktop_clock_weather = lain.widget.weather(
                                  {
        city_id = city_id,
        weather_na_markup = markup.fontfg(beautiful.font_name .. dpi(18),
                                          beautiful.widget_colors
                                              .desktop_clock_weather,
                                          "no forecast available"),
        settings = function()
            descr = weather_now["weather"][1]["description"]:lower()
            units = math.floor(weather_now["main"]["temp"])
            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(18),
                                            beautiful.widget_colors
                                                .desktop_clock_weather, descr) ..
                                  markup.fontfg(beautiful.font_name .. dpi(18),
                                                beautiful.fg_normal, "."))
        end
    })

module.clock = wibox.widget{
    {
        nil,
        deskop_clock_box,
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    {
        desktop_clock_date,
        desktop_clock_weather,
        expand = "none",
        layout = wibox.layout.fixed.horizontal
    },
    expand = "none",
    layout = wibox.layout.fixed.vertical
}

return module
