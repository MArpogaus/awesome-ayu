--------------------------------------------------------------------------------
-- @File:   fs.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- disk usage widgets 
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:29:16
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:20:39
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
local fs_icon = ""

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function()
    fs_widget = lain.widget.fs({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font,
                                            beautiful.widget_colors.fs,
                                            string.format("%.1f", fs_now["/"]
                                                              .percentage) ..
                                                "%"))
        end,
        notification_preset = {
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    })
    beautiful.fs = fs_widget

    return util.create_wibar_widget(beautiful.widget_colors.fs, fs_icon,
                                    fs_widget)
end

module.create_arc_widget = function()
    local fs_widget = lain.widget.fs({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font_name .. dpi(8),
                                            beautiful.widget_colors.desktop_fs
                                                .fg, string.format("%.1f",
                                                                   fs_now["/"]
                                                                       .percentage) ..
                                                "%"))
            widget:emit_signal_recursive("widget::value_changed",
                                         fs_now["/"].percentage)
        end,
        showpopup = "off"
    })
    return util.create_arc_widget(fs_icon, fs_widget,
                                  beautiful.widget_colors.desktop_fs.bg,
                                  beautiful.widget_colors.desktop_fs.fg, 0, 100)
end

-- [ return module objects ] ---------------------------------------------------
return module
