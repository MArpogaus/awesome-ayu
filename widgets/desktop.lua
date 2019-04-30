--[[ ---------------------------------------------------------------------------
     AYU Awesome WM desktop widgets

     inspired by Multicolor Awesome WM beutiful 2.0
     github.com/lcpz
--]] ---------------------------------------------------------------------------
-- [ libraries ]-----------------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")

local markup = lain.util.markup

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local util = require("themes.ayu.util")

local city_id = 2658372

local module = {}

-- [ clock ] -------------------------------------------------------------------
local deskop_clock = wibox.widget.textclock(
                         markup.fontfg(beautiful.font_name .. dpi(48),
                                       beautiful.bg_normal, " %H:%M "))
local deskop_clock_box = util.create_boxed_widget(deskop_clock, 500, 200,
                                                  beautiful.widget_colors
                                                      .desktop_clock)

local desktop_clock_date = wibox.widget.textclock(
                               markup.fontfg(beautiful.font_name .. dpi(18),
                                             beautiful.fg_normal, "Today is ") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.widget_colors
                                                     .desktop_day, "%A") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.fg_normal, ", the ") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.widget_colors
                                                     .desktop_date, "%d.") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.fg_normal, " of ") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.widget_colors
                                                     .desktop_month, "%B") ..
                                   markup.fontfg(beautiful.font_name .. dpi(18),
                                                 beautiful.fg_normal, "."))

module.clock = wibox.widget{
    {
        nil,
        deskop_clock_box,
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    desktop_clock_date,
    layout = wibox.layout.fixed.vertical
}

-- [ weather ] -----------------------------------------------------------------
local markup_color_size = function(size, color, text)
    return markup.fontfg(beautiful.font_name .. dpi(size), color, text)
end
local gen_weather_box = function(color)
    local weather_icon = wibox.widget.textbox()
    local weather_temp = wibox.widget.textbox()
    local weather_temp_min = wibox.widget.textbox()
    local weather_temp_max = wibox.widget.textbox()
    local weather_descr = wibox.widget.textbox()
    local weather_unit = wibox.widget.textbox(
                             markup_color_size(42, color, "°C"))

    local widget = lain.widget.weather({
        city_id = city_id,
        weather_na_markup = markup.fontfg(beautiful.font, color, "N/A "),
        settings = function()
            descr = weather_now["weather"][1]["description"]:lower()
            temp = math.floor(weather_now["main"]["temp"])
            temp_min = math.floor(weather_now["main"]["temp_min"])
            temp_max = math.floor(weather_now["main"]["temp_max"])

            weather_icon:set_markup(util.owf_markup(color, descr, dpi(55)))
            weather_temp:set_markup(markup_color_size(30, color, temp))
            weather_temp_min:set_markup(markup_color_size(8, color,
                                                          temp_min .. ' - '))
            weather_temp_max:set_markup(markup_color_size(8, color, temp_max))
            weather_descr:set_markup(markup_color_size(14, color, descr))
        end
    })

    weather_temp.align = "center"
    weather_descr.align = "center"

    local weather_box = wibox.widget{
        {
            {
                weather_icon,
                nil,
                {
                    {
                        weather_temp,
                        {
                            nil,
                            {
                                weather_temp_min,
                                weather_temp_max,
                                spaceing = dpi(5),
                                layout = wibox.layout.fixed.horizontal
                            },
                            nil,
                            expand = 'outside',
                            layout = wibox.layout.align.horizontal
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    weather_unit,
                    spaceing = dpi(10),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.align.horizontal
            },
            weather_descr,
            spaceing = dpi(15),
            layout = wibox.layout.fixed.vertical
        },
        strategy = "min",
        width = dpi(280),
        layout = wibox.container.constraint
    }

    return weather_box, widget
end

wb, weather_widget = gen_weather_box(beautiful.fg_normal)
beautiful.desktop_weather = weather_widget

module.weather = wibox.widget{
    nil,
    {nil, wb, nil, expand = "none", layout = wibox.layout.align.vertical},
    nil,
    expand = "none",
    layout = wibox.layout.align.horizontal
}
return module
