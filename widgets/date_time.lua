--------------------------------------------------------------------------------
-- @File:   date_time.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- date and time widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:46:19
-- @Changes: 
--      - removed lain
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:40:56
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-10-28 21:38:12
-- @Changes: 
--      - modified desktop clock widget size calculation
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-08-16 13:30:06
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 10:23:31
-- @Changes: 
--      - newly written
--      - ...
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
os.setlocale(os.getenv('LANG')) -- to localize the clock

module.gen_wibar_widget = function()
    local clock_icon = util.fa_ico(beautiful.widget_colors.cal, '')

    local clock_widget = wibox.widget.textclock(
                             util.fontfg(
                                 beautiful.font, beautiful.widget_colors.cal,
                                 '%A %d %B'
                             ) ..
                                 util.fontfg(
                                     beautiful.font, beautiful.fg_normal, ' | '
                                 ) ..
                                 util.fontfg(
                                     beautiful.font,
                                     beautiful.widget_colors.clock, '%H:%M'
                                 )
                         )

    -- popup calendar
    local cal_widget = awful.widget.calendar_popup.month {
        font = beautiful.font_name .. 16,
        week_numbers = true,
        long_weekdays = true,
        opacity = 0.9,
        margin = 5,
        style_header = {border_width = 0},
        style_weekday = {border_width = 0},
        style_weeknumber = {border_width = 0, opacity = 0.5},
        style_normal = {border_width = 0},
        style_focus = {border_width = 0}
    }
    cal_widget:attach(clock_widget, 'tr')

    beautiful.cal = cal_widget

    return util.create_wibar_widget(
               beautiful.widget_colors.cal, clock_icon, clock_widget
           )
end

module.gen_desktop_widget = function()
    local time_font_size = beautiful.desktop_widgets_time_font_size
    local date_font_size = beautiful.desktop_widgets_date_font_size
    local gen_deskop_clock_box = function()
        local deskop_clock = wibox.widget.textclock(
                                 util.fontfg(
                                     beautiful.font_name .. time_font_size,
                                     beautiful.bg_normal, '%H:%M'
                                 )
                             )
        return util.create_boxed_widget(
                   deskop_clock, beautiful.widget_colors.desktop_clock,
                   time_font_size / 2, time_font_size, date_font_size * 1.5
               )
    end

    local gen_desktop_clock_date = function()
        return wibox.widget.textclock(
                   util.fontfg(
                       beautiful.font_name .. date_font_size,
                       beautiful.fg_normal, 'Today is '
                   ) .. util.fontfg(
                       beautiful.font_name .. date_font_size,
                       beautiful.widget_colors.desktop_day, '%A'
                   ) .. util.fontfg(
                       beautiful.font_name .. date_font_size,
                       beautiful.fg_normal, ', the '
                   ) .. util.fontfg(
                       beautiful.font_name .. date_font_size,
                       beautiful.widget_colors.desktop_date, '%d.'
                   ) ..
                       util.fontfg(
                           beautiful.font_name .. date_font_size,
                           beautiful.fg_normal, ' of '
                       ) .. util.fontfg(
                       beautiful.font_name .. date_font_size,
                       beautiful.widget_colors.desktop_month, '%B'
                   ) ..
                       util.fontfg(
                           beautiful.font_name .. date_font_size,
                           beautiful.fg_normal, '.'
                       )
               )
    end

    return wibox.widget {
        nil,
        {

            {
                nil,
                gen_deskop_clock_box(),
                nil,
                expand = 'outside',
                layout = wibox.layout.align.horizontal
            },
            gen_desktop_clock_date(),
            layout = wibox.layout.fixed.vertical
        },
        nil,
        expand = 'outside',
        layout = wibox.layout.align.horizontal
    }
end

-- [ return module object ] ----------------------------------------------------
return module
