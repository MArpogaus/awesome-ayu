local gears = require("gears")
local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local markup = lain.util.markup

local owfont = require("themes.ayu.owfont")

local module = {}

module.fa_markup = function(col, ico, size)
    local font_size = size or beautiful.font_size
    local fa_font = "FontAwesome " .. font_size
    return markup.fontfg(fa_font, col, ico)
end

module.fa_ico = function(col, ico, size, width)
    return wibox.widget{
        markup = module.fa_markup(col, ico, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center',
        forced_width = width or dpi(22)
    }
end

module.owf_markup = function(col, weather_now, size)
    -- ref.: https://github.com/lcpz/lain/blob/master/widget/weather.lua
    local loc_now = os.time() -- local time
    -- local time from midnight
    local loc_m = os.time{
        year = os.date("%Y"),
        month = os.date("%m"),
        day = os.date("%d"),
        hour = 0
    }
    -- table YMDHMS for current local time (for TZ calculation)
    local loc_d = os.date("*t", loc_now)
    -- table YMDHMS for current UTC timelocal utc_now = os.time(utc_d)
    local utc_d = os.date("!*t", loc_now)
    -- UTC time now
    local utc_now = os.time(utc_d)
    if weather_now then
        local sunrise = tonumber(weather_now["sys"]["sunrise"])
        local sunset = tonumber(weather_now["sys"]["sunset"])
        descr = weather_now["weather"][1]["description"]:lower()
        if sunrise <= loc_now and loc_now <= sunset then
            icon = owfont.day[descr] or "N/A"
        else
            icon = owfont.night[descr] or "N/A"
        end
    else
        icon = "N/A"
    end
    local font_size = size or beautiful.font_size
    local owf_font = "owf-regular " .. font_size
    return markup.fontfg(owf_font, col, icon)
end

module.owf_ico = function(col, weather_now, size)
    return wibox.widget{
        markup = module.owf_markup(col, weather_now, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center',
        forced_width = dpi(20)
    }
end

-- stolen from: https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/start_screen.lua
-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
module.create_boxed_widget = function(widget_to_be_boxed, width, height,
                                      bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.shape = function(c, h, w)
        gears.shape.rounded_rect(c, h, w, dpi(15))
    end
    box_container.forced_height = height
    box_container.forced_width = width

    local boxed_widget = wibox.widget{
        -- add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    {
                        -- The actual widget goes here
                        widget_to_be_boxed,
                        height = height,
                        width = width,
                        strategy = "min",
                        layout = wibox.container.constraint
                    },
                    nil,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                nil,
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            widget = box_container
        },
        margins = dpi(24),
        color = "#FF000000",
        widget = wibox.container.margin
    }

    return boxed_widget
end

module.create_wibar_widget = function(color, icon, widget)
    local icon_widget
    if type(icon) == "table" then
        icon_widget = icon
    else
        icon_widget = module.fa_ico(color, icon)
    end
    local wibox_widget = wibox.widget{
        {
            -- add margins
            icon_widget,
            left = dpi(8),
            right = dpi(2),
            color = "#FF000000",
            widget = wibox.container.margin
        },
        widget,
        layout = wibox.layout.fixed.horizontal,
        expand = "none"
    }
    return wibox_widget
end

module.gen_arc_icon = function(fg, icon, size)
    return module.fa_ico(fg, icon, math.floor(size / 8), math.floor(size / 2))
end

module.gen_arc_widget = function(icon, widget, bg, fg, min, max, size, margin,
                                 thickness)
    size = size or dpi(100)
    local icon_widget
    if type(icon) == "table" then
        icon_widget = icon
    else
        icon_widget = module.gen_arc_icon(fg, icon, size)
    end
    widget.align = "center"
    local arc_container = wibox.widget{
        {
            nil,
            {
                nil,
                icon_widget,
                widget,
                expand = "outside",
                layout = wibox.layout.align.vertical
            },
            nil,
            expand = 'outside',
            layout = wibox.layout.align.horizontal
        },
        bg = bg,
        colors = {fg},
        min_value = min,
        max_value = max,
        thickness = thickness or size / 12,
        forced_width = size,
        forced_height = size,
        start_angle = 0,
        widget = wibox.container.arcchart
    }
    local margin_container = wibox.widget{
        arc_container,
        margins = margin or size / 2,
        color = "#FF000000",
        layout = wibox.container.margin
    }
    arc_container:connect_signal("widget::value_changed", function(_, usage)
        arc_container.value = usage
    end)
    return margin_container
end

return module
