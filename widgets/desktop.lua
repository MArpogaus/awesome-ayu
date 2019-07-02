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

-- widgets
local date_time = require("themes.ayu.widgets.date_time")
local weather = require("themes.ayu.widgets.weather")
local cpu = require("themes.ayu.widgets.cpu")
local memory = require("themes.ayu.widgets.memory")
local fs = require("themes.ayu.widgets.fs")
local battery = require("themes.ayu.widgets.battery")

-- user config
local config = require("themes.ayu.config")

local module = {}

-- [ clock ] -------------------------------------------------------------------
module.clock = date_time.gen_desktop_widget()

-- [ weather ] -----------------------------------------------------------------
module.weather = weather.gen_desktop_widget(beautiful.fg_normal, config.city_id)

-- [ arcs ] --------------------------------------------------------------------
module.arcs = wibox.widget{
    nil,
    {
        nil,
        {
            cpu.gen_arc_widget(beautiful.widget_colors.desktop_cpu.bg,
                               beautiful.widget_colors.desktop_cpu.fg),
            memory.gen_arc_widget(beautiful.widget_colors.desktop_mem.bg,
                                  beautiful.widget_colors.desktop_mem.fg),
            fs.gen_arc_widget(beautiful.widget_colors.desktop_fs.bg,
                              beautiful.widget_colors.desktop_fs.fg),
            battery.gen_arc_widget(beautiful.widget_colors.desktop_bat.bg,
                                   beautiful.widget_colors.desktop_bat.fg),
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}
return module
