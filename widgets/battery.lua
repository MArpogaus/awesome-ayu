--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:01
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
local fa_bat_icons = {
    '', -- fa-battery-0 (alias) [&#xf244;]
    '', -- fa-battery-1 (alias) [&#xf243;]
    '', -- fa-battery-2 (alias) [&#xf242;]
    '', -- fa-battery-3 (alias) [&#xf241;]
    '' -- fa-battery-4 (alias) [&#xf240;]
}
-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function(color)
    local bat_icon = util.fa_ico(color, fa_bat_icons[1])
    local bat_widget = lain.widget.bat({
        settings = function()
            local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or
                             bat_now.perc

            widget:set_markup(markup.fontfg(beautiful.font, color, perc))

            if bat_now.ac_status == 1 then
                ico = ''
            else
                ico = fa_bat_icons[math.floor(bat_now.perc / 25) + 1]
            end
            bat_icon:set_markup(util.fa_markup(color, ico))
        end
    })

    return util.create_wibar_widget(color, bat_icon, bat_widget)
end

module.gen_arc_widget = function(bg, fg)
    local bat_icon = util.fa_ico(fg, fa_bat_icons[1], math.floor(dpi(150) / 8),
                                 0)
    local bat_widget = lain.widget.bat({
        settings = function()
            local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or
                             bat_now.perc

            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(12), fg,
                                            perc))

            if bat_now.ac_status == 1 then
                ico = ''
            else
                ico = fa_bat_icons[math.floor(bat_now.perc / 25) + 1]
            end
            bat_icon:set_markup(
                util.fa_markup(fg, ico, math.floor(dpi(150) / 8)))
            widget:emit_signal_recursive("widget::value_changed", bat_now.perc)
        end
    })
    return util.gen_arc_widget(bat_icon, bat_widget, bg, fg, 0, 100, dpi(150))
end

-- [ return module objects ] ---------------------------------------------------
return module
