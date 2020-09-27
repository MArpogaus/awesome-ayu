--------------------------------------------------------------------------------
-- @File:   fs.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- disk usage widgets 
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-27 23:24:15
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

local registered_widgets = {}

local fs_icon = ''
local default_timeout = 60
local default_mount_point = '{/ used_p}'

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(timeout, mount_point)
    -- define widgets
    local fs_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function fs_widget_formatter(_, args)
        return util.fontfg(
                   beautiful.font, beautiful.widget_colors.fs,
                   args[mount_point or default_mount_point] .. '%'
               )
    end

    -- register widgets
    vicious.register(
        fs_widget, vicious.widgets.fs, fs_widget_formatter,
        timeout or default_timeout
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, fs_widget)

    -- return wibar widget
    return util.create_wibar_widget(
               beautiful.widget_colors.fs, fs_icon, fs_widget
           )
end

module.create_arc_widget = function(timeout, mount_point)
    -- define widgets
    local fs_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function fs_widget_formatter(widget, args)
        widget:emit_signal_recursive(
            'widget::value_changed', args[mount_point or default_mount_point]
        )
        return util.fontfg(
                   beautiful.font_name .. 8,
                   beautiful.widget_colors.desktop_fs.fg,
                   args[mount_point or default_mount_point] .. '%'
               )
    end

    -- register widgets
    vicious.register(
        fs_widget, vicious.widgets.fs, fs_widget_formatter,
        timeout or default_timeout
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, fs_widget)

    -- return arc widget
    return util.create_arc_widget(
               fs_icon, fs_widget, beautiful.widget_colors.desktop_fs.bg,
               beautiful.widget_colors.desktop_fs.fg, 0, 100
           )
end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.fs)

-- [ return module object ] -----------.----------------------------------------
return module
