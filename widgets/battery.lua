--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:06:15
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 08:50:41
-- [ description ] -------------------------------------------------------------
-- battery widgets
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
                    return util.markup {
                        font = beautiful.font,
                        fg_color = beautiful.widget_colors.bat,
                        text = args[2] .. '%'
                    }
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
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = beautiful.widget_colors.desktop.bat.fg,
                        text = args[2] .. '%'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
