--------------------------------------------------------------------------------
-- @File:   volume.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- also volume widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-28 17:20:14
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:40:35
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:26:00
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:56:56
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

local fa_vol_icons = {}
fa_vol_icons[0] = '' -- fa-volume-off
fa_vol_icons[1] = '' -- fa-volume-down
fa_vol_icons[2] = '' -- fa-volume-up

local default_timeout = 1

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.volume)

-- [ define widget ] -----------------------------------------------------------
widget_defs.wibar = function(wargs)
    local device = wargs.device or 'Master'
    return {
        default_timeout = default_timeout,
        container_args = {color = beautiful.widget_colors.volume},
        widgets = {
            icon = {
                widget = util.fa_ico(beautiful.widget_colors.vol, 'N/A'),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico =
                            fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return util.fa_markup(beautiful.widget_colors.volume, ico)
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                    else
                        vol = args[1] .. '%'
                    end
                    return util.fa_markup(beautiful.widget_colors.volume, vol)
                end
            }
        }
    }
end
widget_defs.arc = function(wargs)
    local device = wargs.device or 'Master'
    return {
        default_timeout = default_timeout,
        container_args = {
            bg = beautiful.widget_colors.volume.bg,
            fg = beautiful.widget_colors.volume.fg
        },
        widgets = {
            icon = {
                widget = util.fa_ico(beautiful.widget_colors.vol, 'N/A'),
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(_, args)
                    local ico
                    if args[2] == '🔈' then
                        ico = fa_vol_icons[0]
                    else
                        ico =
                            fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
                    end
                    return util.fa_markup(
                               beautiful.widget_colors.volume.fg, ico
                           )
                end
            },
            widget = {
                wtype = vicious.widgets.volume,
                warg = device,
                format = function(widget, args)
                    local vol
                    if args[2] == '🔈' then
                        vol = 'M'
                    else
                        vol = args[1] .. '%'
                    end
                    widget:emit_signal_recursive('widget::value_changed', vol)
                    return util.fontfg(
                               beautiful.font_name .. 8,
                               beautiful.widget_colors.volume.fg, vol
                           )
                end
            }
        }
    }
end

-- [ return module object ] -----------.----------------------------------------
return widgets.new(widget_defs)
