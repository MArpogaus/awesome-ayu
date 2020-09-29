--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- battery widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-29 13:30:28
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
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local fa_bat_icons = {
    '', -- fa-battery-0 (alias) [&#xf244;]
    '', -- fa-battery-1 (alias) [&#xf243;]
    '', -- fa-battery-2 (alias) [&#xf242;]
    '', -- fa-battery-3 (alias) [&#xf241;]
    '' -- fa-battery-4 (alias) [&#xf240;]
}

local default_timeout = 5

-- [ local functions ] ---------------------------------------------------------
local function batt_icon(status, perc)
    local icon = 'N/A'
    if status ~= '⌁' then
        if status == '+' then
            icon = ''
        else
            if perc ~= nil then
                icon = fa_bat_icons[math.floor(perc / 25) + 1]
            end
        end
    end
    return icon
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.bat)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local battery = wargs.battery or 'BAT0'
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.bat},
        widgets = {
            icon = {
                widget = util.fa_ico(beautiful.widget_colors.bat, 'N/A'),
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    local icon = batt_icon(args[1], args[2])
                    return util.fa_markup(beautiful.widget_colors.bat, icon)
                end
            },
            widget = {
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, beautiful.widget_colors.bat,
                               args[2] .. '%'
                           )
                end
            }
        }
    }
end
widget_defs.arc = function(wargs)
    local battery = wargs.battery or 'BAT0'
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop.bat.bg,
            fg = beautiful.widget_colors.desktop.bat.fg
        },
        widgets = {
            icon = {
                widget = util.create_arc_icon(
                    beautiful.widget_colors.desktop.bat.fg, 'N/A', 150
                ),
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    local icon = batt_icon(args[1], args[2])
                    return util.fa_markup(
                               beautiful.widget_colors.desktop.bat.fg, icon,
                               math.floor(150 / 8)
                           )
                end
            },
            widget = {
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed', args[2]
                    )
                    return util.fontfg(
                               beautiful.font_name .. 8,
                               beautiful.widget_colors.desktop.bat.fg,
                               args[2] .. '%'
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
