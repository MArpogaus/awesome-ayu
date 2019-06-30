--------------------------------------------------------------------------------
-- @File:   alsa.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:56:56
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
    local fa_vol_icons = {
        '', -- fa-volume-off [&#xf026;]
        '', -- fa-volume-down [&#xf027;]
        '' -- fa-volume-up [&#xf028;] 
    }
    local vol_icon = lain.widget.alsa({
        settings = function()
            if volume_now.status == "off" then
                ico = fa_vol_icons[1]
            else
                ico = fa_vol_icons[math.floor(volume_now.level / 50) + 2 % 4]
            end
            widget:set_markup(util.fa_markup(color, ico))
        end
    })
    vol_icon.align = 'center'
    vol_icon.valign = 'center'
    vol_icon.forced_width = beautiful.ico_width
    vol_widget = lain.widget.alsa({
        settings = function()
            if volume_now.status == "off" then volume_now.level = "M" end

            widget:set_markup(markup.fontfg(beautiful.font, color,
                                            volume_now.level .. "%"))
        end
    })

    beautiful.volume = vol_widget

    return util.create_wibar_widget(color, vol_icon, vol_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
