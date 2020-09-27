--------------------------------------------------------------------------------
-- @File:   temp.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- cpu temperature widget
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-27 23:26:29
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:16
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-10-28 21:37:23
-- @Changes: 
--      - added tempfile as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:36:28
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:37
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

local default_timeout = 7

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(thermal_zone, timeout)
    -- define widgets
    local temp_icon = ''
    local temp_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function temp_widget_formatter(_, args)
        return util.fontfg(
                   beautiful.font, beautiful.widget_colors.temp,
                   args[1] .. '°C'
               )
    end

    -- register widgets
    vicious.register(
        temp_widget, vicious.widgets.thermal, temp_widget_formatter,
        timeout or default_timeout, thermal_zone
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, temp_widget)

    -- return wibar widget
    return util.create_wibar_widget(
               beautiful.widget_colors.temp, temp_icon, temp_widget
           )
end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.thermal)

-- [ return module object ] -----------.----------------------------------------
return module
