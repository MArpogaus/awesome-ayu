--------------------------------------------------------------------------------
-- @File:   cpu.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu utilization widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:45:59
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
local wibox = require("wibox")
local beautiful = require("beautiful")

local vicious = require("vicious")

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function()
    local cpu_icon = ''
    local cpu_widget = wibox.widget.textbox()
    vicious.register(cpu_widget, vicious.widgets.cpu, util.fontfg(
                         beautiful.font, beautiful.widget_colors.cpu,
                         '$1' .. '%'), 1)
    return util.create_wibar_widget(beautiful.widget_colors.cpu, cpu_icon,
                                    cpu_widget)
end

module.create_arc_widget = function()
    local step_width = 8
    local step_spacing = 4
    local cpu_graph = wibox.widget {
        max_value = 100,
        min_value = 0,
        step_width = step_width,
        step_spacing = step_spacing,
        forced_height = beautiful.desktop_widgets_arc_size / 5,
        color = beautiful.widget_colors.desktop_cpu.fg,
        background_color = "#00000000",
        widget = wibox.widget.graph
    }
    local cpu_graph_widget = wibox.widget {
        nil,
        cpu_graph,
        nil,
        expand = "outside",
        layout = wibox.layout.align.horizontal
    }

    local cpu_widget = wibox.widget.textbox()
    vicious.register(cpu_widget, vicious.widgets.cpu, function(widget, args)
        local num_cpus = #args - 1
        local width = (num_cpus + 1) * (step_width + step_spacing)

        cpu_graph:clear()
        cpu_graph:set_width(width)
        for c = 2, #args do cpu_graph:add_value(args[c] + 1) end
        cpu_graph:add_value(0)
        return util.fontfg(beautiful.font_name .. 8,
                           beautiful.widget_colors.desktop_cpu.fg,
                           args[1] .. '%')
    end, 1)

    return util.create_arc_widget(cpu_graph_widget, cpu_widget,
                                  beautiful.widget_colors.desktop_cpu.bg,
                                  beautiful.widget_colors.desktop_cpu.fg, 0, 100)
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.cpu)

-- [ return module object ] -----------.----------------------------------------
return module
