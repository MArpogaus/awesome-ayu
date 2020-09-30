--------------------------------------------------------------------------------
-- @File:   fs.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:08:16
-- [ description ] -------------------------------------------------------------
-- disk usage widgets 
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

local fs_icon = ''
local default_timeout = 60
local default_mount_point = '{/ used_p}'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.fs)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function()
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.fs},
        widgets = {
            icon = {widget = fs_icon},
            widget = {
                wtype = vicious.widgets.fs,
                format = function(_, args)
                    return util.markup {
                        font = beautiful.font,
                        fg_color = beautiful.widget_colors.fs,
                        text = args[args.mount_point or default_mount_point] ..
                            '%'
                    }
                end
            }
        }
    }
end
widget_defs.arc = function()
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop.fs.bg,
            fg = beautiful.widget_colors.desktop.fs.fg
        },
        widgets = {
            icon = {widget = fs_icon},
            widget = {
                wtype = vicious.widgets.fs,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed',
                        args[args.mount_point or default_mount_point]
                    )
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = beautiful.widget_colors.desktop.fs.fg,
                        text = args[args.mount_point or default_mount_point] ..
                            '%'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
