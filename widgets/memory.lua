--------------------------------------------------------------------------------
-- @File:   memory.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:20:02
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
local mem_icon = ''

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function(color)
    local mem_widget = lain.widget.mem({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color,
                                            mem_now.used .. "M"))
        end
    })

    return util.create_wibar_widget(color, mem_icon, mem_widget)
end

module.gen_arc_widget = function(bg, fg)
    local mem_widget = lain.widget.mem({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(8), fg,
                                            mem_now.perc .. "%"))
            widget:emit_signal_recursive("widget::value_changed", mem_now.perc)
        end
    })
    return util.gen_arc_widget(mem_icon, mem_widget, bg, fg, 0, 100, dpi(150))
end

-- [ return module objects ] ---------------------------------------------------
return module
