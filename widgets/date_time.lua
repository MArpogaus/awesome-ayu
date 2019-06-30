--------------------------------------------------------------------------------
-- @File:   date_time.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:13
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
os.setlocale(os.getenv("LANG")) -- to localize the clock
module.gen_wibar_widget = function(color_date, color_time)
    local clock_icon = util.fa_ico(color_date, '')
    local clock_widget = wibox.widget.textclock(
                             markup(color_date, "%A %d %B") ..
                                 markup(beautiful.fg_normal, " > ") ..
                                 markup(color_time, "%H:%M"))
    clock_widget.font = beautiful.font
    local clock_wibox_widget = util.create_wibar_widget(color_date, clock_icon,
                                                        clock_widget)

    -- popup calendar
    beautiful.cal = lain.widget.cal{
        attach_to = {clock_wibox_widget},
        notification_preset = {
            font = beautiful.font_name .. dpi(10),
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    }

    return clock_wibox_widget
end

-- [ return module objects ] ---------------------------------------------------
return module
