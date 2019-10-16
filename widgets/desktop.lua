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
module.clock = function() return date_time.gen_desktop_widget() end

-- [ weather ] -----------------------------------------------------------------
module.weather =
    function() return weather.gen_desktop_widget(config.city_id) end

-- [ arcs ] --------------------------------------------------------------------
module.arcs = function()
    return wibox.widget{
        nil,
        {
            cpu.create_arc_widget(config.num_cpus),
            memory.create_arc_widget(),
            fs.create_arc_widget(),
            battery.create_arc_widget(),
            spacing = dpi(100),
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "outer",
        layout = wibox.layout.align.vertical
    }
end
return module
