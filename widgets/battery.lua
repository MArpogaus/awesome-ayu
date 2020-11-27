--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 09:33:42
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

local default_timeout = 15
local default_bat = 'BAT0'
local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal

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
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color
    local battery = warg.battery or default_bat

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {
                widget = util.fa_ico(color, 'N/A'),
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    local icon = batt_icon(args[1], args[2])
                    return util.fa_markup(color, icon)
                end
            },
            widget = {
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    return util.markup {
                        fg_color = color,
                        text = args[2] .. '%'
                    }
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color
    local battery = warg.battery or default_bat

    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color},
        widgets = {
            icon = {
                widget = util.create_arc_icon(fg_color, 'N/A', 150),
                wtype = vicious.widgets.bat,
                warg = battery,
                format = function(_, args)
                    local icon = batt_icon(args[1], args[2])
                    return util.fa_markup(fg_color, icon, math.floor(150 / 8))
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
                        fg_color = fg_color,
                        text = args[2] .. '%'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
