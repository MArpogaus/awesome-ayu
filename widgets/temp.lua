--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu temperature widget
-- [ changelog ] ---------------------------------------------------------------
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
module.gen_wibar_widget = function(tempfile)
    local temp_icon = ''
    local temp_widget = lain.widget.temp(
                            {
            tempfile = tempfile,
            settings = function()
                widget:set_markup(markup.fontfg(beautiful.font,
                                                beautiful.widget_colors.temp,
                                                coretemp_now .. "°C"))
            end
        })

    return util.create_wibar_widget(beautiful.widget_colors.temp, temp_icon,
                                    temp_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
