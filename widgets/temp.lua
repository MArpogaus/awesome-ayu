--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:37
-- @Changes: 
--      - newly written
--      - ...
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function(color)
    local temp_icon = ''
    local temp_widget = lain.widget.temp(
                            {
            tempfile = '/sys/class/thermal/thermal_zone1/temp',
            settings = function()
                widget:set_markup(markup.fontfg(beautiful.font, color,
                                                coretemp_now .. "°C"))
            end
        })

    return util.create_wibar_widget(color, temp_icon, temp_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
