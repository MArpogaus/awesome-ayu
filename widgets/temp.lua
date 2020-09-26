--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu temperature widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:49:14
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:16
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-10-28 21:37:23
-- @Changes: 
--      - added tempfile as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:36:28
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:37
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local beautiful = require("beautiful")
local wibox = require("wibox")

local vicious = require("vicious")

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(thermal_zone)
    local temp_icon = ''
    local temp_widget = wibox.widget.textbox()
    vicious.register(temp_widget, vicious.widgets.thermal, util.fontfg(
                         beautiful.font, beautiful.widget_colors.temp, '$1°C'),
                     5, thermal_zone)

    return util.create_wibar_widget(beautiful.widget_colors.temp, temp_icon,
                                    temp_widget)
end


-- [ sequential code ] ---------------------------------------------------------
-- enable caching
--vicious.cache(vicious.widgets.temp)

-- [ return module object ] -----------.----------------------------------------
return module
