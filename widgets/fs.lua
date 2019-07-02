--------------------------------------------------------------------------------
-- @File:   fs.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:20:39
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
local fs_icon = ""

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function(color)
    fs_widget = lain.widget.fs({
        notification_preset = {
            font = beautiful.font_name .. dpi(10),
            fg = beautiful.fg_normal
        },
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color,
                                            string.format("%.1f", fs_now["/"]
                                                              .percentage) ..
                                                "%"))
        end
    })
    beautiful.fs = fs_widget

    return util.create_wibar_widget(color, fs_icon, fs_widget)
end

module.gen_arc_widget = function(bg, fg)
    local fs_widget = lain.widget.fs({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(8), fg,
                                            string.format("%.1f", fs_now["/"]
                                                              .percentage) ..
                                                "%"))
            widget:emit_signal_recursive("widget::value_changed",
                                         fs_now["/"].percentage)
        end,
        showpopup = "off"
    })
    return util.gen_arc_widget(fs_icon, fs_widget, bg, fg, 0, 100, dpi(150))
end

-- [ return module objects ] ---------------------------------------------------
return module
