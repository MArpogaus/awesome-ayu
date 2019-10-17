--------------------------------------------------------------------------------
-- @File:   theme.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-30 20:36:28
-- [ description ] -------------------------------------------------------------
--   AYU Awesome WM theme 0.1
--
--   inspired by Multicolor Awesome WM theme 2.0
--   github.com/lcpz
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-17 14:54:24
-- @Changes: 
--      - newly written
--      - ...
--------------------------------------------------------------------------------
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = require("themes.ayu.ayu_theme")
local color_schemes = require("themes.ayu.color_schemes")

-- user config
local config = require("themes.ayu.config")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = config.icon_theme or "HighContrast"

function theme.at_screen_connect(s)
    -- load custom wibox widgets
    local wibox_widgets = require("themes.ayu.widgets.wibox")
    local desktop_widgets = require("themes.ayu.widgets.desktop")

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Create a promptbox for each screen
    if s.promptbox == nil then s.mypromptbox = awful.widget.prompt() end
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    if s.mylayoutbox == nil then
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(my_table.join(
                                  awful.button({}, 1, function()
                awful.layout.inc(1)
            end), awful.button({}, 2, function()
                awful.layout.set(awful.layout.layouts[1])
            end), awful.button({}, 3, function() awful.layout.inc(-1) end),
                                  awful.button({}, 4, function()
                awful.layout.inc(1)
            end), awful.button({}, 5, function() awful.layout.inc(-1) end)))
    end

    -- Create a taglist widget
    if s.mytaglist == nil then
        awful.tag(awful.util.tagnames, s, awful.layout.layouts)
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all,
                                           awful.util.taglist_buttons)
    end
    -- Create a tasklist widget
    if s.mytasklist == nil then
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter
                                                 .currenttags,
                                             awful.util.tasklist_buttons)
    end

    -- Create a weather widgets
    local wibox_weather, wibox_weather_wdiget =
        wibox_widgets.weather(config.city_id)
    local desktop_weather, desktop_weather_widget =
        desktop_widgets.weather(config.city_id)

    -- Create the desktop widget popup
    s.desktop_popup = awful.popup{
        widget = {
            {
                -- Center widgets vertically
                nil,
                {
                    -- Center widgets horizontally
                    desktop_widgets.arcs(),
                    desktop_widgets.clock(),
                    desktop_weather,
                    expand = "outside",
                    layout = wibox.layout.align.vertical
                },
                nil,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            widget = wibox.container.constraint,
            forced_width = s.workarea.width * 0.8,
            forced_height = s.workarea.height * 0.8
        },
        type= "desktop",
        placement = awful.placement.centered,
        visible = true,
        bg= "#00000000",
        input_passthrough=true
    }
    s.desktop_popup:buttons(root.buttons())

    -- Create the wibox
    if s.mywibox then
        s.mywibox:remove()
        s.mywibox = nil
    end

    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        height = theme.top_bar_height,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- s.mylayoutbox,
            -- awful.util.mylauncher,
            s.mytaglist,
            s.mypromptbox,
            wibox_widgets.mpd()
        },
        -- Middle widgets
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox_widgets.net(theme.widget_colors.netdown, "received"),
            wibox_widgets.net(theme.widget_colors.netup, "sent",
                              {wibox_weather_wdiget, desktop_weather_widget}),
            wibox_widgets.vol(),
            wibox_widgets.mem(),
            wibox_widgets.cpu(),
            wibox_widgets.fs(),
            wibox_weather,
            wibox_widgets.temp(),
            wibox_widgets.bat(),
            wibox_widgets.datetime(),
            {
                -- add margins
                awful.util.myexitmenu,
                left = dpi(8),
                widget = wibox.container.margin
            }
        }
    }

    -- Create the bottom wibox
    if s.mybottomwibox then
        s.mybottomwibox:remove()
        s.mybottomwibox = nil
    end

    s.mybottomwibox = awful.wibar({
        position = "bottom",
        screen = s,
        border_width = 0,
        height = theme.bottom_bar_height,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            wibox.widget.systray(),
            s.mylayoutbox,
            layout = wibox.layout.fixed.horizontal
        }
    }
end

theme.set_dark = function(self) self:set_color_scheme(color_schemes.dark) end

theme.set_light = function(self) self:set_color_scheme(color_schemes.light) end

theme.set_mirage =
    function(self) self:set_color_scheme(color_schemes.mirage) end

return theme
