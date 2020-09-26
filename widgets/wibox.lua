--------------------------------------------------------------------------------
-- @File:   wibox.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-07-15 08:12:41
-- [ description ] -------------------------------------------------------------
-- wibar widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:40:49
-- @Changes: 
--      - ported to vicious
--      - removed mpd wdiget
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-24 20:06:33
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:51:52
-- @Changes: 
--      - added header
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local date_time = require('themes.ayu.widgets.date_time')
local weather = require('themes.ayu.widgets.weather')
local fs = require('themes.ayu.widgets.fs')
local cpu = require('themes.ayu.widgets.cpu')
local temp = require('themes.ayu.widgets.temp')
local battery = require('themes.ayu.widgets.battery')
local volume = require('themes.ayu.widgets.volume')
local net = require('themes.ayu.widgets.net')
local memory = require('themes.ayu.widgets.memory')

-- [ local objects ] -----------------------------------------------------------
local module = {
    weather = weather.gen_wibar_widget,
    net = net.gen_wibar_widget,
    vol = volume.gen_wibar_widget,
    mem = memory.gen_wibar_widget,
    cpu = cpu.gen_wibar_widget,
    temp = temp.gen_wibar_widget,
    bat = battery.gen_wibar_widget,
    fs = fs.gen_wibar_widget,
    datetime = date_time.gen_wibar_widget
}

-- [ return module object ] -----------.----------------------------------------
return module
