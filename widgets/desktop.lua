--------------------------------------------------------------------------------
-- @File:   desktop.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-11-18 10:19:01
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:08:27
-- [ description ] -------------------------------------------------------------
-- desktop widgets
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
-- [ libraries ]-----------------------------------------------------------------
local wibox = require('wibox')
local beautiful = require('beautiful')

-- widgets
local date_time = require('themes.ayu.widgets.date_time')
local weather = require('themes.ayu.widgets.weather')

local cpu = require('themes.ayu.widgets.cpu')
local memory = require('themes.ayu.widgets.memory')
local fs = require('themes.ayu.widgets.fs')
local battery = require('themes.ayu.widgets.battery')

local module = {}

-- [ clock ] -------------------------------------------------------------------
module.clock = date_time.create_desktop_widget

-- [ weather ] -----------------------------------------------------------------
module.weather = weather.create_desktop_widget

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
        expand = 'outer',
        layout = wibox.layout.align.vertical
    }
end

-- [ return module ] -----------------------------------------------------------
return module
