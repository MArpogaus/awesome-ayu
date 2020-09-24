--------------------------------------------------------------------------------
-- @File:   desktop.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-11-18 10:19:01
-- [ description ] -------------------------------------------------------------
-- AYU Awesome WM desktop widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-24 16:32:56
-- @Changes: 
--      - code format
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:03
-- @Changes: 
--      - added header
--      - removed apply_dpi to make use of new DPI handling in v4.3
----------------------------------------------------------------------------------
-- [ libraries ]-----------------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")

local markup = lain.util.markup

local util = require("themes.ayu.util")

-- widgets
local date_time = require("themes.ayu.widgets.date_time")
local weather = require("themes.ayu.widgets.weather")
local cpu = require("themes.ayu.widgets.cpu")
local memory = require("themes.ayu.widgets.memory")
local fs = require("themes.ayu.widgets.fs")
local battery = require("themes.ayu.widgets.battery")

local module = {}

-- [ clock ] -------------------------------------------------------------------
module.clock = date_time.gen_desktop_widget

-- [ weather ] -----------------------------------------------------------------
module.weather = weather.gen_desktop_widget

-- [ arcs ] --------------------------------------------------------------------
module.arcs = function()
    return wibox.widget {
        nil,
        {
            cpu.create_arc_widget(),
            memory.create_arc_widget(),
            fs.create_arc_widget(),
            battery.create_arc_widget(),
            spacing = beautiful.desktop_widgets_arc_spacing,
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "outer",
        layout = wibox.layout.align.vertical
    }
end
return module
