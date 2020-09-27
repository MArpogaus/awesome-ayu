--------------------------------------------------------------------------------
-- @File:   volume.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- also volume widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-27 23:26:20
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
local wibox = require('wibox')

local vicious = require('vicious')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local registered_widgets = {}

local fa_vol_icons = {}
fa_vol_icons[0] = '' -- fa-volume-off
fa_vol_icons[1] = '' -- fa-volume-down
fa_vol_icons[2] = '' -- fa-volume-up

local default_timeout = 1

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(timeout)
    -- define widgets
    local vol_icon = util.fa_ico(beautiful.widget_colors.vol, 'N/A')
    local vol_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function vol_icon_formatter(_, args)
        local ico
        if args[1] == '🔈' then
            ico = fa_vol_icons[0]
        else
            ico = fa_vol_icons[math.min(math.ceil(args[1] / 50), 2)]
        end
        return util.fa_markup(beautiful.widget_colors.volume, ico)
    end
    local function vol_widget_formatter(_, args)
        local vol
        if args[2] == '🔈' then
            vol = 'M'
        else
            vol = args[1] .. '%'
        end
        return util.fa_markup(beautiful.widget_colors.volume, vol)
    end

    -- register widgets
    vicious.register(
        vol_icon, vicious.widgets.volume, vol_icon_formatter,
        timeout or default_timeout, 'Master'
    )
    vicious.register(
        vol_widget, vicious.widgets.volume, vol_widget_formatter,
        timeout or default_timeout, 'Master'
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, vol_icon)
    table.insert(registered_widgets, vol_widget)

    -- return wibar widget
    return util.create_wibar_widget(
               beautiful.widget_colors.vol, vol_icon, vol_widget
           )
end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.volume)

-- [ return module object ] -----------.----------------------------------------
return module
