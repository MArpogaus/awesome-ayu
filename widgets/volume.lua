--------------------------------------------------------------------------------
-- @File:   volume.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:08:55
-- [ description ] -------------------------------------------------------------
-- alsa volume widget
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

local fa_vol_icons = {}
fa_vol_icons[0] = '' -- fa-volume-off
fa_vol_icons[1] = '' -- fa-volume-down
fa_vol_icons[2] = '' -- fa-volume-up

local default_timeout = 1

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.volume)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local device = wargs.device or 'Master'
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.volume},
        widgets = {
            icon = {
                widget = util.fa_ico(beautiful.widget_colors.volume, 'N/A'),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico =
                            fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return util.fa_markup(beautiful.widget_colors.volume, ico)
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                    else
                        vol = args[1] .. '%'
                    end
                    return util.fa_markup(beautiful.widget_colors.volume, vol)
                end
            }
        }
    }
end
widget_defs.arc = function(wargs)
    local device = wargs.device or 'Master'
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop.volume.bg,
            fg = beautiful.widget_colors.desktop.volume.fg
        },
        widgets = {
            icon = {
                widget = util.create_arc_icon(
                    beautiful.widget_colors.desktop.volume.fg, 'N/A', 150
                ),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico =
                            fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return util.fa_markup(
                               beautiful.widget_colors.desktop.volume.fg, ico,
                               math.floor(150 / 8)
                           )
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(widget, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                        widget:emit_signal_recursive('widget::value_changed', 0)
                    else
                        vol = args[1] .. '%'
                        widget:emit_signal_recursive(
                            'widget::value_changed', args[1]
                        )
                    end
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = beautiful.widget_colors.desktop.volume.fg,
                        text = vol
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
