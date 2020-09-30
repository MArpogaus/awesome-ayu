--------------------------------------------------------------------------------
-- @File:   net.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:08:45
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
                    return util.markup {
                        font = beautiful.font,
                        fg_color = color,
                        text = args['{' .. interface .. ' ' .. value .. '_kb}'] ..
                            'kb'
                    }
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
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = color_fg,
                        text = args['{' .. interface .. ' ' .. value .. '_kb}'] ..
                            'kb'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
