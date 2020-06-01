--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- battery widgets
-- [ changelog ] ---------------------------------------------------------------
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
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")

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
function batt_icon()
    local icon = 'N/A'
    if bat_now.ac_status == 1 then
        icon = ''
    else
        if bat_now.perc ~= "N/A" then
            icon = fa_bat_icons[math.floor(bat_now.perc / 25) + 1]
        end
    end
    return icon
end
module.gen_wibar_widget = function()
    local bat_icon = util.fa_ico(beautiful.widget_colors.bat, fa_bat_icons[1])
    local bat_widget = lain.widget.bat({
        settings = function()
            local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or
                             bat_now.perc

            widget:set_markup(markup.fontfg(beautiful.font,
                                            beautiful.widget_colors.bat, perc))

            local icon = batt_icon()
            bat_icon:set_markup(
                util.fa_markup(beautiful.widget_colors.bat, icon))
        end
    })

    return util.create_wibar_widget(beautiful.widget_colors.bat, bat_icon,
                                    bat_widget)
end

module.create_arc_widget = function()
    local bat_icon = util.create_arc_icon(beautiful.widget_colors.desktop_bat.fg,
                                       fa_bat_icons[1], 150)
    local bat_widget = lain.widget.bat({
        settings = function()
            local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or
                             bat_now.perc

            widget:set_markup(markup.fontfg(beautiful.font_name .. 8,
                                            beautiful.widget_colors.desktop_bat
                                                .fg, perc))

            icon = batt_icon()
            bat_icon:set_markup(util.fa_markup(
                                    beautiful.widget_colors.desktop_bat.fg,
                                    icon, math.floor(150 / 8)))
            widget:emit_signal_recursive("widget::value_changed", bat_now.perc)
        end,
        notify = "off"
    })
    return util.create_arc_widget(bat_icon, bat_widget,
                                  beautiful.widget_colors.desktop_bat.bg,
                                  beautiful.widget_colors.desktop_bat.fg, 0, 100)
end

-- [ return module objects ] ---------------------------------------------------
return module
