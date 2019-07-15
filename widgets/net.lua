--------------------------------------------------------------------------------
-- @File:   net.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- networking widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:18:06
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local lain = require("lain")
local beautiful = require("beautiful")
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}
local net_icons = {received = '', sent = ''}
-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function(color, type, weather_widgets)
    local net_icon = net_icons[type]
    local net_widget = lain.widget.net({
        settings = function()
            widget:set_markup(
                markup.fontfg(beautiful.font, color, net_now[type]))

            for _, ww in pairs(weather_widgets or {}) do
                if iface ~= "network off" and
                    string.match(ww.widget.text, "N/A") then
                    ww.update()

                end
            end
        end
    })

    return util.create_wibar_widget(color, net_icon, net_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
