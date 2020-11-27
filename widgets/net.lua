--------------------------------------------------------------------------------
-- @File:   net.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 14:03:48
-- [ description ] -------------------------------------------------------------
-- networking widgets
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local net_icons = {down = '', up = ''}

local default_timeout = 3
local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal
local default_interface = 'eth0'
local default_value = 'down'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.net)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color
    local interface = warg.interface or default_interface
    local value = warg.value or default_value

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(_, args)
                    local val =
                        args['{' .. interface .. ' ' .. value .. '_kb}'] or -1
                    return util.markup {fg_color = color, text = val .. 'kb'}
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local interface = warg.interface or default_interface
    local value = warg.value or default_value

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color, max = 50 * 1024},
        widgets = {
            icon = {widget = net_icons[value]},
            widget = {
                wtype = vicious.widgets.net,
                format = function(widget, args)
                    local val =
                        args['{' .. interface .. ' ' .. value .. '_kb}'] or -1
                    widget:emit_signal_recursive('widget::value_changed', val)
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = fg_color,
                        text = val .. 'kb'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
