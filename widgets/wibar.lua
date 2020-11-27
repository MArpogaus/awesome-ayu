--------------------------------------------------------------------------------
-- @File:   wibar.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-07-15 08:12:41
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 11:27:34
-- [ description ] -------------------------------------------------------------
-- wibar widgets
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
local battery = require('themes.ayu.widgets.battery')
local cpu = require('themes.ayu.widgets.cpu')
local date_time = require('themes.ayu.widgets.date_time')
local fs = require('themes.ayu.widgets.fs')
local memory = require('themes.ayu.widgets.memory')
local net = require('themes.ayu.widgets.net')
local temp = require('themes.ayu.widgets.temp')
local volume = require('themes.ayu.widgets.volume')
local weather = require('themes.ayu.widgets.weather')

-- [ local objects ] -----------------------------------------------------------
local module = {
    weather = weather.create_wibar_widget,
    net_down = function(warg)
        warg.value = 'down'
        return net.create_wibar_widget(warg)
    end,
    net_up = function(warg)
        warg.value = 'up'
        return net.create_wibar_widget(warg)
    end,
    vol = volume.create_wibar_widget,
    mem = memory.create_wibar_widget,
    cpu = cpu.create_wibar_widget,
    temp = temp.create_wibar_widget,
    bat = battery.create_wibar_widget,
    fs = fs.create_wibar_widget,
    datetime = date_time.create_wibar_widget
}

-- [ return module ] -----------------------------------------------------------
return module
