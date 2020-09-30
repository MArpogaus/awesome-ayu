--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:08:50
-- [ description ] -------------------------------------------------------------
-- cpu temperature widget
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

local temp_icon = ''
local default_timeout = 7

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.thermal)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local thermal_zone = wargs.thermal_zone or 'thermal_zone0'
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.temp},
        widgets = {
            icon = {widget = temp_icon},
            widget = {
                wtype = vicious.widgets.thermal,
                warg = thermal_zone,
                format = function(_, args)
                    return util.markup {
                        font = beautiful.font,
                        fg_color = beautiful.widget_colors.temp,
                        text = args[1] .. '°C'
                    }
                end
            }
        }
    }
end
widget_defs.arc = function(wargs)
    local thermal_zone = wargs.thermal_zone or 'thermal_zone0'
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop.temp.bg,
            fg = beautiful.widget_colors.desktop.temp.fg
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
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = beautiful.widget_colors.desktop.temp.fg,
                        text = args[1] .. '°C'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
