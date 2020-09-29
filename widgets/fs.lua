--------------------------------------------------------------------------------
-- @File:   fs.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- disk usage widgets 
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-29 13:26:52
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
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local widgets = require('themes.ayu.widgets')

-- [ local objects ] -----------------------------------------------------------
local widget_defs = {}

local fs_icon = ''
local default_timeout = 60
local default_mount_point = '{/ used_p}'

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.fs)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function()
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.fs},
        widgets = {
            icon = {widget = fs_icon},
            widget = {
                wtype = vicious.widgets.fs,
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, beautiful.widget_colors.fs,
                               args[args.mount_point or default_mount_point] ..
                                   '%'
                           )
                end
            }
        }
    }
end
widget_defs.arc = function()
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.desktop.fs.bg,
            fg = beautiful.widget_colors.desktop.fs.fg
        },
        widgets = {
            icon = {widget = fs_icon},
            widget = {
                wtype = vicious.widgets.fs,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed',
                        args[args.mount_point or default_mount_point]
                    )
                    return util.fontfg(
                               beautiful.font_name .. 8,
                               beautiful.widget_colors.desktop.fs.fg,
                               args[args.mount_point or default_mount_point] ..
                                   '%'
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
