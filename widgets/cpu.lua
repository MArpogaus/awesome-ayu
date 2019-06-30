--------------------------------------------------------------------------------
-- @File:   cpu.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:09
-- @Changes: 
--      - newly written
--      - ...
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
module.gen_wibar_widget = function(color)
    local cpu_icon = ''
    local cpu_widget = lain.widget.cpu({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color,
                                            cpu_now.usage .. "%"))
        end
    })
    return util.create_wibar_widget(color, cpu_icon, cpu_widget)
end

module.gen_arc_widget = function(bg, fg)
    local num_cpus = 8
    local step_width = dpi(8)
    local step_spacing = dpi(4)
    local cpu_graph = wibox.widget{
        max_value = 100,
        min_value = 0,
        step_width = step_width,
        step_spacing = step_spacing,
        forced_width = (num_cpus + 1) * (step_width + step_spacing),
        forced_height = dpi(50),
        color = fg,
        background_color = "#00000000",
        widget = wibox.widget.graph
    }
    local cpu_widget = lain.widget.cpu({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(12), fg,
                                            cpu_now.usage .. "%"))
            widget:emit_signal_recursive("widget::value_changed", cpu_now.usage)
            cpu_graph:clear()
            for i, v in ipairs(cpu_now) do
                cpu_graph:add_value(v.usage)
            end
            cpu_graph:add_value(0)
        end
    })
    cpu_widget.align = "center"

    return util.gen_arc_widget(cpu_graph, cpu_widget, bg, fg, 0, 100, dpi(150))
end

-- [ return module objects ] ---------------------------------------------------
return module
