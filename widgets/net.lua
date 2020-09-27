--------------------------------------------------------------------------------
-- @File:   net.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- networking widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-27 23:22:49
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:18:06
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

local net_icons = {down = '', up = ''}

local default_timeout = 3

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(color, interface, type, timeout)
    -- define widgets
    local net_icon = net_icons[type]
    local net_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function net_widget_formatter(_, args)
        return util.fontfg(
                   beautiful.font, color,
                   args['{' .. interface .. ' ' .. type .. '_kb}'] .. 'kb'
               )
    end

    -- register widgets
    vicious.register(
        net_widget, vicious.widgets.net, net_widget_formatter,
        timeout or default_timeout
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, net_widget)

    -- return wibar widget
    return util.create_wibar_widget(color, net_icon, net_widget)
end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
-- vicious.cache(vicious.widgets.net)

-- [ return module object ] -----------.----------------------------------------
return module
