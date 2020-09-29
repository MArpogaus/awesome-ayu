--------------------------------------------------------------------------------
-- @File:   net.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- networking widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-29 13:44:28
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:18:06
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

local net_icons = {down = '', up = ''}

local default_timeout = 3

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.net)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local color, interface, value = wargs.color, wargs.interface, wargs.value
    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, color, args['{' .. interface ..
                                   ' ' .. value .. '_kb}'] .. 'kb'
                           )
                end
            }
        }
    }
end
widget_defs.arc = function(wargs)
    local color_bg, color_fg, interface, value = wargs.color_bg,
                                                 wargs.color_fg,
                                                 wargs.interface, wargs.value

    return {
        default_timeout = default_timeout,
        container_args = {bg = color_bg, fg = color_fg, max = 50 * 1024},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed',
                        args['{' .. interface .. ' ' .. value .. '_kb}']
                    )
                    return util.fontfg(
                               beautiful.font_name .. 8, color_fg, args['{' ..
                                   interface .. ' ' .. value .. '_kb}'] .. 'kb'
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
