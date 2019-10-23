--------------------------------------------------------------------------------
-- @File:   cpu.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cup utilization widgets
-- [ changelog ] ---------------------------------------------------------------
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
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function()
    local cpu_icon = ''
    local cpu_widget = lain.widget.cpu({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font,
                                            beautiful.widget_colors.cpu,
                                            cpu_now.usage .. "%"))
        end
    })
    return util.create_wibar_widget(beautiful.widget_colors.cpu, cpu_icon,
                                    cpu_widget)
end

module.create_arc_widget = function()
    local step_width = dpi(8)
    local step_spacing = dpi(4)
    local cpu_graph = wibox.widget{
        max_value = 100,
        min_value = 0,
        step_width = step_width,
        step_spacing = step_spacing,
        forced_height = beautiful.desktop_widgets_arc_size / 5,
        color = beautiful.widget_colors.desktop_cpu.fg,
        background_color = "#00000000",
        widget = wibox.widget.graph
    }
    local cpu_graph_widget = wibox.widget{
        nil,
        cpu_graph,
        nil,
        expand = "outside",
        layout = wibox.layout.align.horizontal
    }
    local cpu_widget = lain.widget.cpu({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(8),
                                            beautiful.widget_colors.desktop_cpu
                                                .fg, cpu_now.usage .. "%"))
            widget:emit_signal_recursive("widget::value_changed", cpu_now.usage)
            local num_cpus = #cpu_now
            local width = (num_cpus + 1) * (step_width + step_spacing)
            
            cpu_graph:clear()
            cpu_graph:set_width(width)
            for i, v in ipairs(cpu_now) do
                cpu_graph:add_value(v.usage)
            end
            cpu_graph:add_value(0)
        end
    })
    cpu_widget.align = "center"

    return util.create_arc_widget(cpu_graph_widget, cpu_widget,
                                  beautiful.widget_colors.desktop_cpu.bg,
                                  beautiful.widget_colors.desktop_cpu.fg, 0, 100)
end

-- [ return module objects ] ---------------------------------------------------
return module
