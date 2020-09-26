--------------------------------------------------------------------------------
-- @File:   fs.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- disk usage widgets 
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:48:18
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:07
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
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
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local fs_icon = ''

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function()
    local fs_widget = wibox.widget.textbox()
    vicious.register(fs_widget, vicious.widgets.fs,
                     util.fontfg(beautiful.font, beautiful.widget_colors.fs,
                                 '${/ used_p}%'), 30)

    return util.create_wibar_widget(beautiful.widget_colors.fs, fs_icon,
                                    fs_widget)
end

module.create_arc_widget = function()
    local fs_widget = wibox.widget.textbox()
    vicious.register(fs_widget, vicious.widgets.fs,
                     util.fontfg(beautiful.font_name .. 8,
                                 beautiful.widget_colors.desktop_fs.fg,
                                 '${/ used_p}%'), 30)

    return util.create_arc_widget(fs_icon, fs_widget,
                                  beautiful.widget_colors.desktop_fs.bg,
                                  beautiful.widget_colors.desktop_fs.fg, 0, 100)
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.fs)

-- [ return module object ] -----------.----------------------------------------
return module
