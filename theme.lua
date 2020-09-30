--------------------------------------------------------------------------------
-- @File:   theme.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-30 20:36:28
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-09-30 09:07:12
-- [ description ] -------------------------------------------------------------
-- AYU Awesome WM theme 0.1
--
-- inspired by Multicolor Awesome WM theme 2.0
-- github.com/lcpz
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
local gears = require('gears')
local gfs = require('gears.filesystem')

local awful = require('awful')
local wibox = require('wibox')

local theme = require('themes.ayu.ayu_theme')
local color_schemes = require('themes.ayu.color_schemes')

-- custom wibox widgets
local wibox_widgets = require('themes.ayu.widgets.wibox')
local desktop_widgets = require('themes.ayu.widgets.desktop')

-- [ local objects ] -----------------------------------------------------------
-- user config
local config = {
    -- Your city for the weather forcast widget
    city_id = 42,
    app_id = 'N/A',

    -- Load color schemes from xresources
    use_xresources = false,
    -- Network interface
    net_interface = 'wlp4s0b1'
}

-- [ module variables ] --------------------------------------------------------
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = config.icon_theme or 'HighContrast'

-- [ module functions ] --------------------------------------------------------
theme.at_screen_connect = function(s)
    if config.dpi then s.dpi = config.dpi end

    if s.desktop_popup then
        s.desktop_popup.widget:reset()
        s.desktop_popup = nil
    end
    if s.mytopwibar then
        s.mytopwibar.widget:reset()
        s.mytopwibar:remove()
        s.mytopwibar = nil
    end
    if s.mybottomwibar then
        s.mybottomwibar.widget:reset()
        s.mybottomwibar:remove()
        s.mybottomwibar = nil
    end
    if s.promptbox then
        s.promptbox:reset()
        s.promptbox:remove()
        s.promptbox = nil
    end
    if s.mytaglist then
        s.mytaglist:reset()
        s.mytaglist:remove()
        s.mytaglist = nil
    else
        -- Each screen has its own tag table.
        awful.tag(
            awful.util.tagnames, s,
            awful.layout.default[s.index] or awful.layout.layouts[1]
        )
    end

    -- If wallpaper is a function, call it with the screen
    local wallpaper = config.wallpaper or theme.wallpaper
    if type(wallpaper) == 'function' then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
        gears.table.join(
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(1) end),
            awful.button({}, 5, function() awful.layout.inc(-1) end)
        )
    )

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons
    }

    -- Create the desktop widget popup
    s.desktop_popup = awful.popup {
        widget = {
            {
                -- Center widgets vertically
                nil,
                {
                    -- Center widgets horizontally
                    desktop_widgets.arcs(),
                    desktop_widgets.clock(),
                    desktop_widgets.weather {
                        city_id = config.city_id,
                        app_id = config.app_id
                    },
                    expand = 'outside',
                    layout = wibox.layout.align.vertical
                },
                nil,
                expand = 'none',
                layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.constraint,
            forced_width = s.workarea.width,
            forced_height = s.workarea.height
        },
        type = 'desktop',
        screen = s,
        placement = awful.placement.centered,
        visible = true,
        bg = '#00000000',
        shape_input = root.wallpaper(),
        input_passthrough = true
    }

    -- Create the wibox
    s.mytopwibar = awful.wibar(
                       {
            position = 'top',
            screen = s,
            height = theme.top_bar_height,
            bg = theme.bg_normal,
            fg = theme.fg_normal
        }
                   )

    -- Add widgets to the wibox
    local myexitmenu = nil
    if awful.util.myexitmenu then
        awful.util.myexitmenu.image = theme.exitmenu_icon
        myexitmenu = {
            -- add margins
            awful.util.myexitmenu,
            left = theme.icon_margin_left,
            widget = wibox.container.margin
        }
    end
    s.mytopwibar:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- s.mylayoutbox,
            -- awful.util.mylauncher,
            s.mytaglist,
            s.mypromptbox
        },
        -- Middle widgets
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox_widgets.net {
                color = theme.widget_colors.netdown,
                interface = config.net_interface,
                value = 'down'
            },
            wibox_widgets.net {
                color = theme.widget_colors.netup,
                interface = config.net_interface,
                value = 'up'
            },
            wibox_widgets.vol(),
            wibox_widgets.mem(),
            wibox_widgets.cpu(),
            wibox_widgets.fs(),
            wibox_widgets.weather {
                city_id = config.city_id,
                app_id = config.app_id
            },
            wibox_widgets.temp {thermal_zone = config.thermal_zone},
            wibox_widgets.bat(),
            wibox_widgets.datetime(),
            myexitmenu
        }
    }

    -- Create the bottom wibox
    s.mybottomwibar = awful.wibar(
                          {
            position = 'bottom',
            screen = s,
            height = theme.bottom_bar_height,
            bg = theme.bg_normal,
            fg = theme.fg_normal
        }
                      )

    -- Add widgets to the bottom wibox
    s.systray = wibox.widget.systray()
    s.mybottomwibar:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            s.systray,
            awful.widget.keyboardlayout(),
            s.mylayoutbox,
            spacing = theme.icon_margin_left,
            layout = wibox.layout.fixed.horizontal
        }
    }

    -- show systray on focused screen
    s.systray_set_screen = function()
        if s.systray then s.systray:set_screen(s) end
    end

    s.mybottomwibar:connect_signal('mouse::enter', s.systray_set_screen)

    local focused_screen = awful.screen.focused()
    focused_screen.systray:set_screen(focused_screen)
end

theme.set_dark = function(self) self:set_color_scheme(color_schemes.dark) end

theme.set_light = function(self) self:set_color_scheme(color_schemes.light) end

theme.set_mirage =
    function(self) self:set_color_scheme(color_schemes.mirage) end

-- [ sequential code ] ---------------------------------------------------------
if gfs.file_readable(gfs.get_configuration_dir() .. 'config.lua') then
    config = gears.table.crush(config, require('config'))
end
local color_scheme
if config.use_xresources then
    color_scheme = color_schemes.xrdb()
else
    color_scheme = color_schemes.light
end

theme:set_color_scheme(color_scheme)

-- [ return module ] -----------------------------------------------------------
return theme
