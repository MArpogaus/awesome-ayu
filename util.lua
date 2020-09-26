--------------------------------------------------------------------------------
-- @File:   util.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-07-15 07:46:40
-- [ description ] -------------------------------------------------------------
-- collection of utility functions
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 18:43:00
-- @Changes: 
--      - added fontfg
--      - updated owf_markup for vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 15:34:14
-- @Changes: 
--      - fixed icon width
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:40:23
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:40:16
-- @Changes: 
--      - optimized boxed widget for different sizes
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-08-19 16:07:04
-- @Changes: 
--      - added header
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local gears = require('gears')
local cairo = require('lgi').cairo
local wibox = require('wibox')
local beautiful = require('beautiful')

local owfont = require('themes.ayu.owfont')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
-- Helper functions for modifying hex colors -----------------------------------
local hex_color_match = '[a-fA-F0-9][a-fA-F0-9]'
module.darker = function(color_value, darker_n)
    local result = '#'
    local channel_counter = 1
    for s in color_value:gmatch(hex_color_match) do
        local bg_numeric_value = tonumber('0x' .. s)
        if channel_counter <= 3 then
            bg_numeric_value = bg_numeric_value - darker_n
        end
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format('%02x', bg_numeric_value)
        channel_counter = channel_counter + 1
    end
    return result
end
module.is_dark = function(color_value)
    local bg_numeric_value = 0
    local channel_counter = 1
    for s in color_value:gmatch(hex_color_match) do
        bg_numeric_value = bg_numeric_value + tonumber('0x' .. s)
        if channel_counter == 3 then break end
        channel_counter = channel_counter + 1
    end
    local is_dark_bg = (bg_numeric_value < 383)
    return is_dark_bg
end
module.reduce_contrast = function(color, ratio)
    ratio = ratio or 50
    if module.is_dark(color) then
        return module.darker(color, -ratio)
    else
        return module.darker(color, ratio)
    end
end

-- create titlebar_button ------------------------------------------------------
module.titlebar_button = function(size, radius, bg_color, fg_color,
                                  border_width)
    border_width = border_width or 1
    -- Create a surface
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)

    -- Create a context
    local cr = cairo.Context(img)

    -- paint transparent bg
    cr:set_source(gears.color('#00000000'))
    cr:paint()

    -- draw border
    cr:set_source(gears.color(fg_color or '#00000000'))
    cr:move_to(size / 2 + radius, size / 2)
    cr:arc(size / 2, size / 2, radius + border_width, 0, 2 * math.pi)
    cr:close_path()
    cr:fill()

    -- draw circle
    cr:set_source(gears.color(bg_color))
    cr:move_to(size / 2 + radius, size / 2)
    cr:arc(size / 2, size / 2, radius, 0, 2 * math.pi)
    cr:close_path()
    cr:fill()

    return img, cr
end

-- FontAwesome icons -----------------------------------------------------------
module.fa_markup = function(col, ico, size)
    local font_size = size or beautiful.font_size
    local fa_font = 'FontAwesome ' .. font_size
    return module.fontfg(fa_font, col, ico)
end

module.fa_ico = function(col, ico, size, width)
    return wibox.widget {
        markup = module.fa_markup(col, ico, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center',
        forced_width = width or beautiful.ico_width
    }
end

-- owfont icons ----------------------------------------------------------------
module.owf_markup = function(col, weather, sunrise, sunset, size)
    local loc_now = os.time() -- local time
    local icon
    if weather then
        weather = weather:lower()
        if type(sunrise, sunset) == 'number' and sunrise + sunrise > 0 then
            if sunrise <= loc_now and loc_now <= sunset then
                icon = owfont.day[weather] or 'N/A'
            else
                icon = owfont.night[weather] or 'N/A'
            end
        else
            icon = owfont.day[weather] or 'N/A'
        end
    else
        icon = 'N/A'
    end
    local font_size = size or beautiful.font_size
    local owf_font = 'owf-regular ' .. font_size
    return module.fontfg(owf_font, col, icon)
end
module.owf_ico = function(col, weather_now, size, width)
    return wibox.widget {
        markup = module.owf_markup(col, weather_now, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center',
        forced_width = width or beautiful.ico_width
    }
end

-- stolen from: https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/start_screen.lua
-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
module.create_boxed_widget = function(widget_to_be_boxed, bg_color, radius,
                                      inner_margin, outer_margin)
    radius = radius or 15
    inner_margin = inner_margin or 30
    outer_margin = outer_margin or 30
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.shape = function(c, h, w)
        gears.shape.rounded_rect(c, h, w, radius)
    end

    local boxed_widget = wibox.widget {
        {
            {
                widget_to_be_boxed,
                margins = inner_margin,
                widget = wibox.container.margin
            },
            widget = box_container
        },
        bottom = outer_margin,
        widget = wibox.container.margin
    }

    return boxed_widget
end

module.create_wibar_widget = function(color, icon, widget)
    local icon_widget
    if type(icon) == 'table' then
        icon_widget = icon
    else
        icon_widget = module.fa_ico(color, icon)
    end
    local wibox_widget = wibox.widget {
        {
            -- add margins
            icon_widget,
            left = beautiful.icon_margin_left,
            right = beautiful.icon_margin_right,
            color = '#FF000000',
            widget = wibox.container.margin
        },
        widget,
        layout = wibox.layout.fixed.horizontal,
        expand = 'none'
    }
    return wibox_widget
end

module.create_arc_icon = function(fg, icon, size)
    return module.fa_ico(fg, icon, math.floor(size / 8), math.floor(size / 2))
end
module.create_arc_widget = function(icon, widget, bg, fg, min, max, size,
                                    thickness)
    size = size or beautiful.desktop_widgets_arc_size
    local icon_widget
    if type(icon) == 'table' then
        icon_widget = icon
    else
        icon_widget = module.create_arc_icon(fg, icon, size)
    end
    widget.align = 'center'
    local arc_container = wibox.widget {
        {
            nil,
            {
                nil,
                {
                    nil,
                    icon_widget,
                    widget,
                    expand = 'outside',
                    layout = wibox.layout.align.vertical
                },
                nil,
                expand = 'inside',
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
        thickness = thickness or math.sqrt(size),
        forced_width = size,
        forced_height = size,
        start_angle = 0,
        widget = wibox.container.arcchart
    }
    arc_container:connect_signal('widget::value_changed', function(_, usage)
        arc_container.value = usage
    end)
    return arc_container
end

module.fontfg = function(font, fg, text)
    return string.format('<span font=\'%s\' foreground=\'%s\'>%s</span>', font,
                         fg, text)
end

return module
