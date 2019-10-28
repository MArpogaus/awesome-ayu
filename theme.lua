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
-- @Last Modified time: 2019-10-28 21:44:14
-- @Changes: 
--      - added tempfile as function argument to temperature widget
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-17 14:54:24
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
local gears = require("gears")
local gfs = require("gears.filesystem")

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
local config = {
    -- Your city for the weather forcast widget
    city_id = 2658372,
    -- Load color schemes from xresources
    use_xresources = false
}
if gfs.file_readable(gfs.get_configuration_dir() .. "config.lua") then
    config = require("config")
end
local color_schemes = require("themes.ayu.color_schemes")

if config.use_xresources then
    color_scheme = color_schemes.xrdb()
else
    color_scheme = color_schemes.light
end

theme:set_color_scheme(color_scheme)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = config.icon_theme or "HighContrast"

function theme.at_screen_connect(s)

    if s.desktop_popup then
        s.desktop_popup.widget:reset()
        s.mytopwibar.desktop_popup = nil
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
        awful.tag(awful.util.tagnames, s, awful.layout.layouts[2])
    end

    -- load custom wibox widgets
    local wibox_widgets = require("themes.ayu.widgets.wibox")
    local desktop_widgets = require("themes.ayu.widgets.desktop")

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)


    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons
    }

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
            forced_width = s.workarea.width,
            forced_height = s.workarea.height
        },
        type = "desktop",
        placement = awful.placement.centered,
        visible = true,
        bg = "#00000000",
        shape_input = root.wallpaper()
    }

    -- Create the wibox
    s.mytopwibar = awful.wibar({
        position = "top",
        screen = s,
        height = theme.top_bar_height,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the wibox
    local myexitmenu = nil
    if awful.util.myexitmenu then
        awful.util.myexitmenu.image=theme.exitmenu_icon
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
            wibox_widgets.temp(config.tempfile),
            wibox_widgets.bat(),
            wibox_widgets.datetime(),
            myexitmenu
        }
    }

    -- Create the bottom wibox
    s.mybottomwibar = awful.wibar({
        position = "bottom",
        screen = s,
        height = theme.bottom_bar_height,
        bg = theme.bg_normal,
        fg = theme.fg_normal
    })

    -- Add widgets to the bottom wibox
    s.mybottomwibar:setup{
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            wibox.widget.systray(),
            s.mylayoutbox,
            spacing= theme.icon_margin_left,
            layout = wibox.layout.fixed.horizontal
        }
    }
end

theme.set_dark = function(self) self:set_color_scheme(color_schemes.dark) end

theme.set_light = function(self) self:set_color_scheme(color_schemes.light) end

theme.set_mirage =
    function(self) self:set_color_scheme(color_schemes.mirage) end

return theme
