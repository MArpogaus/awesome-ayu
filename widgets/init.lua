--------------------------------------------------------------------------------
-- @File:   init.lua
-- @Author: Marcel Arpogaus
-- @Date:   2020-09-26 20:19:50
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 20:25:28
-- @Changes: 
-- 		- newly written
-- 		- ...
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- battery widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 20:14:37
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-06-01 11:14:16
-- @Changes: 
--      - fixes for new lain version
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:40:43
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:31:41
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:43:15
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local gears = require('gears')

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
local module = {}

-- [ module functions ] --------------------------------------------------------
module.get_registered_widgets = function()
    return gears.table.join(date_time.registered_widgets,
                            weather.registered_widgets, fs.registered_widgets,
                            cpu.registered_widgets, temp.registered_widgets,
                            battery.registered_widgets,
                            volume.registered_widgets, net.registered_widgets,
                            memory.registered_widgets)
end

-- [ return module object ] -----------.----------------------------------------
return module
