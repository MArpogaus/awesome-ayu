--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu temperature widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-28 17:21:03
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
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local temp_icon = ''
local default_timeout = 7

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.thermal)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local thermal_zone = wargs.thermal_zone
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.temp},
        widgets = {
            icon = {widget = temp_icon},
            widget = {
                wtype = vicious.widgets.thermal,
                warg = thermal_zone,
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, beautiful.widget_colors.temp,
                               args[1] .. '°C'
                           )
                end
            }
        }
    }
end
widget_defs.arc = function(wargs)
    local thermal_zone = wargs.thermal_zone
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop_temp.bg,
            fg = beautiful.widget_colors.desktop_temp.fg
        },
        widgets = {
            icon = {widget = temp_icon},
            widget = {
                wtype = vicious.widgets.thermal,
                warg = thermal_zone,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed', args[1]
                    )
                    return util.fontfg(
                               beautiful.font_name .. 8,
                               beautiful.widget_colors.desktop_temp.bg,
                               args[1] .. '°C'
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
