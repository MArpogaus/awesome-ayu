--------------------------------------------------------------------------------
-- @File:   volume.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- also volume widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:47:22
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
local beautiful = require("beautiful")
local wibox = require("wibox")

local vicious = require("vicious")

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

local fa_vol_icons = {}
fa_vol_icons[0] = '' -- fa-mute
fa_vol_icons[1] = '' -- fa-volume-off
fa_vol_icons[2] = '' -- fa-volume-down
fa_vol_icons[3] = '' -- fa-volume-up

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function()
    local vol_icon = util.fa_ico(beautiful.widget_colors.volume, "N/A")
    local vol_widget = wibox.widget.textbox()
    vicious.register(vol_widget, vicious.widgets.volume, function(widget, args)
        if args[2] == "🔈" then
            ico = fa_vol_icons[0]
            vol = "M"
        else
            ico = fa_vol_icons[math.min(math.ceil(args[1] / 33),3)]
            vol = args[1] .. '%'
        end
        vol_icon:set_markup(util.fa_markup(beautiful.widget_colors.volume, ico))
        return util.fa_markup(beautiful.widget_colors.volume, vol)
    end, 1, 'Master')

    return util.create_wibar_widget(beautiful.widget_colors.volume, vol_icon,
                                    vol_widget)
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
-- vicious.cache(vicious.widgets.volume)

-- [ return module object ] -----------.----------------------------------------
return module
