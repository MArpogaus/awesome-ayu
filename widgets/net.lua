--------------------------------------------------------------------------------
-- @File:   net.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- networking widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:46:53
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:18:06
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local wibox = require("wibox")
local beautiful = require("beautiful")

local vicious = require("vicious")

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}
local net_icons = {down = '', up = ''}

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(color, interface, type)
    local net_icon = net_icons[type]
    local net_widget = wibox.widget.textbox()
    vicious.register(net_widget, vicious.widgets.net, util.fontfg(
                         beautiful.font, color,
                         '${' .. interface .. ' ' .. type .. '_kb}kb'), 1)

    return util.create_wibar_widget(color, net_icon, net_widget)
end


-- [ sequential code ] ---------------------------------------------------------
-- enable caching
--vicious.cache(vicious.widgets.net)

-- [ return module object ] -----------.----------------------------------------
return module
