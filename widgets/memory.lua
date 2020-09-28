--------------------------------------------------------------------------------
-- @File:   memory.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- memory widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-28 17:19:00
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:10
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:41:56
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:20:02
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

local mem_icon = ''

local default_timeout = 7

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.mem)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function()
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.memory},
        widgets = {
            icon = {widget = mem_icon},
            widget = {
                wtype = vicious.widgets.mem,
                format = function(_, args)
                    return util.fontfg(
                               beautiful.font, beautiful.widget_colors.memory,
                               args[1] .. '%'
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
            bg = beautiful.widget_colors.desktop_mem.bg,
            fg = beautiful.widget_colors.desktop_mem.fg
        },
        widgets = {
            icon = {widget = mem_icon},
            widget = {
                wtype = vicious.widgets.mem,
                format = function(widget, args)
                    widget:emit_signal_recursive(
                        'widget::value_changed', args[1]
                    )
                    return util.fontfg(
                               beautiful.font_name .. 8,
                               beautiful.widget_colors.desktop_mem.fg,
                               args[1] .. '%'
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
