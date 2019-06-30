--------------------------------------------------------------------------------
-- @File:   weather.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:43
-- @Changes: 
--      - newly written
--      - ...
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local lain = require("lain")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function(color, city_id)
    local weather_icon = util.owf_ico(color)
    local weather_widget = lain.widget.weather(
                               {
            city_id = city_id,
            notification_preset = {
                font = beautiful.font_name .. dpi(10),
                fg = beautiful.fg_normal,
                bg = beautiful.bg_normal
            },
            weather_na_markup = markup.fontfg(beautiful.font, color, "N/A"),
            settings = function()
                descr = weather_now["weather"][1]["description"]:lower()
                units = math.floor(weather_now["main"]["temp"])
                widget:set_markup(markup.fontfg(beautiful.font, color, descr ..
                                                    " @ " .. units .. "°C"))
                weather_icon:set_markup(util.owf_markup(color, weather_now))
            end
        })
    beautiful.weather = weather_widget

    return util.create_wibar_widget(color, weather_icon, weather_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
