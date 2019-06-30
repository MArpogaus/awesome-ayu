--[[ ---------------------------------------------------------------------------
     AYU Awesome WM wibar widgets

     inspired by Multicolor Awesome WM beutiful 2.0
     github.com/lcpz
--]] ---------------------------------------------------------------------------
local os = os

local gears = require("gears")
local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- widgets
local date_time = require("themes.ayu.widgets.date_time")
local weather = require("themes.ayu.widgets.weather")
local fs = require("themes.ayu.widgets.fs")
local cpu = require("themes.ayu.widgets.cpu")
local temp = require("themes.ayu.widgets.temp")
local battery = require("themes.ayu.widgets.battery")
local alsa = require("themes.ayu.widgets.alsa")
local net = require("themes.ayu.widgets.net")
local memory = require("themes.ayu.widgets.memory")
local mpd = require("themes.ayu.widgets.mpd")

local city_id = 2658372

local module = {
    weather = weather.gen_wibar_widget(beautiful.widget_colors.weather, city_id),
    netdown = net.gen_wibar_widget(beautiful.widget_colors.netdown, "received"),
    netup = net.gen_wibar_widget(beautiful.widget_colors.netup, "sent",
                                 {beautiful.weather, beautiful.desktop_weather}),
    vol = alsa.gen_wibar_widget(beautiful.widget_colors.volume),
    mem = memory.gen_wibar_widget(beautiful.widget_colors.memory),
    cpu = cpu.gen_wibar_widget(beautiful.widget_colors.cpu),
    temp = temp.gen_wibar_widget(beautiful.widget_colors.temp),
    bat = battery.gen_wibar_widget(beautiful.widget_colors.bat),
    fs = fs.gen_wibar_widget(beautiful.widget_colors.fs),
    mpd = mpd.gen_wibar_widget(beautiful.widget_colors.mpd),
    datetime = date_time.gen_wibar_widget(beautiful.widget_colors.cal,
                                          beautiful.widget_colors.clock)
}

return module
