--------------------------------------------------------------------------------
-- @File:   cpu.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-02 10:03:20
-- [ description ] -------------------------------------------------------------
-- cpu utilization widgets
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
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local default_timeout = 1

local default_fg_color = beautiful.fg_normal
local default_bg_color = beautiful.bg_normal

local step_width = 8
local step_spacing = 4

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.cpu)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(warg)
    local color = warg.color or default_fg_color

    return {
        default_timeout = default_timeout,
        container_args = {color = color},
        widgets = {
            icon = {widget = ''},
            widget = {
                wtype = vicious.widgets.cpu,
                format = function(_, args)
                    return util.markup {
                        fg_color = color,
                        text = args[1] .. '%'
                    }
                end
            }
        }
    }
end
widget_defs.arc = function(warg)
    local fg_color = warg.fg_color or default_fg_color
    local bg_color = warg.bg_color or default_bg_color

    local cpu_graph = wibox.widget {
        max_value = 100,
        min_value = 0,
        step_width = step_width,
        step_spacing = step_spacing,
        forced_height = beautiful.desktop_widgets_arc_size / 5,
        color = fg_color,
        background_color = '#00000000',
        widget = wibox.widget.graph
    }
    return {
        default_timeout = default_timeout,
        container_args = {bg = bg_color, fg = fg_color},
        widgets = {
            icon = {
                widget = wibox.widget {
                    nil,
                    cpu_graph,
                    nil,
                    expand = 'outside',
                    layout = wibox.layout.align.horizontal
                },
                wtype = vicious.widgets.cpu,
                format = function(_, args)
                    local num_cpus = #args - 1
                    local width = (num_cpus + 1) * (step_width + step_spacing)

                    cpu_graph:clear()
                    cpu_graph:set_width(width)
                    for c = 2, #args do
                        cpu_graph:add_value(args[c] + 1)
                    end
                    cpu_graph:add_value(0)
                end
            },
            widget = {
                wtype = vicious.widgets.cpu,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed', args[1]
                    )
                    return util.markup {
                        font = beautiful.font_name .. 8,
                        fg_color = fg_color,
                        text = args[1] .. '%'
                    }
                end
            }
        }
    }
end

-- [ return module ] -----------------------------------------------------------
return widgets.new(widget_defs)
