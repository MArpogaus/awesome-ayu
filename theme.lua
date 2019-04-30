--[[
     AYU Awesome WM theme 0.1

     inspired by Multicolor Awesome WM theme 2.0
     github.com/lcpz
--]] local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = require("themes.ayu.ayu_theme")
local ayu_colors = require("themes.ayu.ayu_colors")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "HighContrast"
-- theme.icon_theme = "flattrcolor"

function theme.at_screen_connect(s)
    -- load custom wibox widgets
    local wibox_widgets = require("themes.ayu.widgets.wibox")
    local desktop_widgets = require("themes.ayu.widgets.desktop")

    -- Quake application
    if not s.quake then
        s.quake = lain.util.quake({app = awful.util.terminal})
    end

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Create a promptbox for each screen
    if not s.promptbox then s.mypromptbox = awful.widget.prompt() end
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    if not s.mylayoutbox then
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(my_table.join(
                                  awful.button({}, 1,
                                               function()
                awful.layout.inc(1)
            end), awful.button({}, 2,
                               function()
                awful.layout.set(awful.layout.layouts[1])
            end), awful.button({}, 3, function() awful.layout.inc(-1) end),
                                  awful.button({}, 4,
                                               function()
                awful.layout.inc(1)
            end), awful.button({}, 5, function() awful.layout.inc(-1) end)))
    end
    -- Create a taglist widget
    if not s.mytaglist then
        awful.tag(awful.util.tagnames, s, awful.layout.layouts)
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all,
                                           awful.util.taglist_buttons)
    end
    -- Create a tasklist widget
    if not s.mytasklist then
        s.mytasklist = awful.widget.tasklist(s,
                                             awful.widget.tasklist.filter
                                                 .currenttags,
                                             awful.util.tasklist_buttons)
    end

    -- Create the wibox
    if s.mywibox then s.mywibox:remove() end
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
            s.mytaglist,
            s.mypromptbox,
            wibox_widgets.mpd
        },
        -- Middle widgets
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox_widgets.netdown,
            wibox_widgets.netup,
            wibox_widgets.vol,
            wibox_widgets.mem,
            wibox_widgets.cpu,
            wibox_widgets.fs,
            wibox_widgets.weather,
            wibox_widgets.temp,
            wibox_widgets.bat,
            wibox_widgets.datetime
        }
    }

    -- Create the bottom wibox
    if s.mybottomwibox then s.mybottomwibox:remove() end
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
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox
        }
    }

    -- Create the desktop wibox
    s.desktop_widget = wibox({
        x = s.workarea.x,
        y = s.workarea.y,
        screen = s,
        visible = true,
        ontop = false,
        width = s.workarea.width,
        height = s.workarea.height
        -- fg = theme.fg_normal
    })

    -- Add widgets to desktop wibox
    s.desktop_widget:setup{
        -- Center widgets vertically
        nil,
        {
            -- Center widgets horizontally
            nil,
            desktop_widgets.clock,
            desktop_widgets.weather,
            expand = "outside",
            layout = wibox.layout.align.vertical
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
end

theme.set_dark = function(self) self:set_color_scheme(ayu_colors.dark) end

theme.set_light = function(self) self:set_color_scheme(ayu_colors.light) end

theme.set_mirage = function(self) self:set_color_scheme(ayu_colors.mirage) end

return theme
