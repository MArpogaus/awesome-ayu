--------------------------------------------------------------------------------
-- @File:   util.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-07-15 07:46:40
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-08 08:20:01
-- [ description ] -------------------------------------------------------------
-- collection of utility functions
-- [ license ] -----------------------------------------------------------------
-- MIT License
-- Copyright (c) 2020 Marcel Arpogaus
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
-- [ required modules ] --------------------------------------------------------
local capi = {screen = screen}

local os = os
local string = string

local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
local gfs = require('gears.filesystem')
local cairo = require('lgi').cairo
local wibox = require('wibox')
local beautiful = require('beautiful')

local owfont = require('themes.ayu.owfont')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ local functions ] ---------------------------------------------------------
local function set_xconf(property, value, sleep)
    local xconf = string.format(
                      'xfconf-query -c xsettings --property %s --set \'%s\'',
                      property, value
                  )
    if sleep then xconf = string.format('sleep %.1f && %s', sleep, xconf) end
    naughty.notify {text = xconf}
    awful.spawn.with_shell(xconf)
end
local function set_wpg_colorscheme(theme)
    awful.spawn.with_shell(string.format('wpg -s %s.png', theme))
end
local function set_subl_colorscheme(theme)
    local subl_prefs = string.format(
                           '%s/.config/sublime-text-3/Packages/User' ..
                               '/Preferences.sublime-settings',
                           os.getenv('HOME')
                       )
    awful.spawn.with_shell(
        string.format(
            'sed -i \'s:ayu-\\(light\\|dark\\|mirage\\):ayu-%s:\' \'%s\'',
            theme, subl_prefs
        )
    )
end
local function reload_emacs_theme()
    awful.spawn.with_shell(
        'pgrep emacs && emacsclient -e "(doom/reload-theme)"'
    )
end
local function set_icon_colorscheme(theme)
    set_xconf('/Net/IconThemeName', theme)
end
local function set_gtk_colorscheme()
    set_xconf('/Net/ThemeName', '')
    set_xconf('/Net/ThemeName', 'FlatColor', 1)
end
local current_cs
local function set_color_scheme(cs, ico)
    if current_cs ~= cs then
        current_cs = cs
        local theme = beautiful.get()
        theme['set_' .. cs](theme)
        -- update awesome colorscheme
        awful.screen.connect_for_each_screen(beautiful.at_screen_connect)

        -- update gtk/rofi colorscheme
        set_wpg_colorscheme(cs)
        -- update sublime colorscheme
        set_subl_colorscheme(cs)
        -- update emacs theme
        reload_emacs_theme()
        -- update icon theme
        set_icon_colorscheme(ico)
        -- update gtk theme
        set_gtk_colorscheme()
    end
    local clients = awful.screen.focused().clients
    for _, c in ipairs(clients) do
        if c.titlebars_enabled then
            c:emit_signal('request::titlebars')
        end
    end

end

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
module.set_alpha = function(color, alpha)
    local alpha_hex = string.format('%02x', math.floor(alpha * 2.56))
    return string.sub(color, 1, 7) .. alpha_hex
end

-- create titlebar_button ------------------------------------------------------
module.titlebar_button = function(
    size, radius, bg_color, fg_color, border_width
)
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
    return module.markup {font = fa_font, fg_color = col, text = ico}
end

module.fa_ico = function(col, ico, size)
    return wibox.widget {
        markup = module.fa_markup(col, ico, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center'
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
    return module.markup {font = owf_font, fg_color = col, text = icon}
end
module.owf_ico = function(col, weather_now, size)
    return wibox.widget {
        markup = module.owf_markup(col, weather_now, size),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center'
    }
end

-- inspired by: https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/start_screen.lua
-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
module.create_boxed_widget = function(
    widget_to_be_boxed,
    bg_color,
    radius,
    inner_margin,
    outer_margin
)
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

module.create_wibar_widget = function(args)
    local icon_widget
    if type(args.icon) == 'table' then
        icon_widget = args.icon
    else
        icon_widget = module.fa_ico(args.color, args.icon)
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
        args.widget,
        layout = wibox.layout.fixed.horizontal,
        expand = 'none'
    }
    return wibox_widget
end

module.create_arc_icon = function(fg, icon, size)
    return module.fa_ico(fg, icon, math.floor(size / 8))
end

module.create_arc_widget = function(args)
    local icon = args.icon
    local widget = args.widget
    local bg = args.bg
    local fg = args.fg
    local min = args.min or 0
    local max = args.max or 100
    local size = args.size or beautiful.desktop_widgets_arc_size
    local thickness = args.thickness or math.sqrt(size)

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
        value = 0,
        thickness = thickness,
        forced_width = size,
        forced_height = size,
        start_angle = 0,
        widget = wibox.container.arcchart
    }
    arc_container:connect_signal(
        'widget::value_changed',
        function(_, usage) arc_container.value = usage end
    )
    return arc_container
end

module.markup = function(args)
    local style = ''
    local font, fg_color, text = args.font, args.fg_color, args.text
    if font then style = style .. string.format(' font=\'%s\'', font) end
    if fg_color then
        style = style .. string.format(' foreground=\'%s\'', fg_color)
    end
    return string.format('<span %s>%s</span>', style, text)
end

-- Load configuration file
module.load_config = function(config_file)
    local config = {
        -- load color schemes from xresources
        xresources = false,
        color_scheme = 'light',

        -- icon theme to use
        icon_theme = 'HighContrast',

        -- enable / disable desktop widget
        desktop_widgets = true,

        -- widgets to be added to wibar
        wibar_widgets = {
            'net_down',
            'net_up',
            'vol',
            'mem',
            'cpu',
            'fs',
            'weather',
            'temp',
            'bat',
            'datetime'
        },

        -- widgets to be added to the desktop pop up
        arc_widgets = {'cpu', 'mem', 'fs', 'bat'}
    }
    if gfs.file_readable(gfs.get_configuration_dir() .. 'config.lua') then
        config = gears.table.crush(config, require(config_file or 'config'))
    end
    return config
end

-- change colorschemes
module.set_dark = function() set_color_scheme('dark', 'flattrcolor') end
module.set_mirage = function() set_color_scheme('mirage', 'flattrcolor') end
module.set_light = function() set_color_scheme('light', 'flattrcolor-dark') end

-- change dpi
module.inc_dpi = function(inc)
    for s in capi.screen do
        s.dpi = s.dpi + inc
        set_xconf('/Xft/DPI', math.floor(s.dpi))
    end
end
module.dec_dpi = function(dec) module.inc_dpi(-dec) end

-- manage widgets
module.toggle_widgets = function()
    for s in capi.screen do s.toggle_widgets() end
end
module.update_widgets = function()
    for s in capi.screen do s.update_widgets() end
end
module.toggle_desktop_widget_visibility =
    function()
        for s in capi.screen do s.toggle_desktop_widget_visibility() end
    end

-- [ return module ] -----------------------------------------------------------
return module
