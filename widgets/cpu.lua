--------------------------------------------------------------------------------
-- @File:   cpu.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu utilization widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-28 17:16:56
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:43:42
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-08-16 12:17:19
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:19:20
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local default_timeout = 1

local step_width = 8
local step_spacing = 4

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.cpu)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function()
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.cpu},
        widgets = {
            icon = {widget = ''},
            widget = {
                wtype = vicious.widgets.cpu,
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, beautiful.widget_colors.cpu,
                               args[1] .. '%'
                           )
                end
            }
        }
    }
end
widget_defs.arc = function()
    local cpu_graph = wibox.widget {
        max_value = 100,
        min_value = 0,
        step_width = step_width,
        step_spacing = step_spacing,
        forced_height = beautiful.desktop_widgets_arc_size / 5,
        color = beautiful.widget_colors.desktop_cpu.fg,
        background_color = '#00000000',
        widget = wibox.widget.graph
    }
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop_cpu.bg,
            fg = beautiful.widget_colors.desktop_cpu.fg
        },
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
                    return util.fontfg(
                               beautiful.font_name .. 8,
                               beautiful.widget_colors.desktop_cpu.fg,
                               args[1] .. '%'
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
