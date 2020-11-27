--------------------------------------------------------------------------------
-- @File:   theme.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-30 20:36:28
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-11-27 14:28:46
-- [ description ] -------------------------------------------------------------
-- AYU Awesome WM theme
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
local root = root

local gears = require('gears')

local awful = require('awful')
local wibox = require('wibox')

local vicious = require('vicious')

local util = require('themes.ayu.util')
local theme = require('themes.ayu.ayu_theme')
local color_schemes = require('themes.ayu.color_schemes')

-- custom wibox widgets
local wibar_widgets = require('themes.ayu.widgets.wibar')
local desktop_widgets = require('themes.ayu.widgets.desktop')

-- configuration
local config = util.load_config()

-- [ module variables ] --------------------------------------------------------
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = config.icon_theme

-- [ module functions ] --------------------------------------------------------
theme.at_screen_connect = function(s)
    -- unregister widgets
    if s.reset then s.reset() end

    if config.dpi then s.dpi = config.dpi end

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
    if config.arc_widgets then
        local arc_widget_containers = {
            spacing = theme.desktop_widgets_arc_spacing,
            layout = wibox.layout.fixed.horizontal
        }
        s.registered_desktop_widgets = {}
        for i, w in pairs(config.arc_widgets) do
            local midx = #theme.widgets.desktop.arcs
            local cidx = (i - 1) % midx + 1
            local bg_color = theme.widgets.desktop.arcs[cidx]
            local fg_color = util.reduce_contrast(bg_color, 50)
            local warg = config.widgets_arg[w] or
                             config.widgets_arg[gears.string.split(w, '_')[1]] or
                             {}
            warg = gears.table.clone(warg)
            warg.fg_color = warg.fg_color or fg_color
            warg.bg_color = warg.bg_color or bg_color
            local widget_container, registered_widgets =
                desktop_widgets.arcs[w](warg)
            table.insert(arc_widget_containers, widget_container)
            s.registered_desktop_widgets =
                gears.table.join(
                    s.registered_desktop_widgets, registered_widgets
                )
        end
        local desktop_widgets_clock_container, desktop_widgets_clock_widgets =
            desktop_widgets.clock()
        local desktop_widgets_weather_container,
              desktop_widgets_weather_widgets =
            desktop_widgets.weather(s, config.widgets_arg.weather)
        s.registered_desktop_widgets = gears.table.join(
                                           s.registered_desktop_widgets,
                                           desktop_widgets_weather_widgets,
                                           desktop_widgets_clock_widgets
                                       )
        s.desktop_widget_containers = gears.table.join(
                                          arc_widget_containers,
                                          desktop_widgets_weather_container,
                                          desktop_widgets_clock_container
                                      )
        s.desktop_popup = awful.popup {
            widget = {
                {
                    -- Center widgets vertically
                    nil,
                    {
                        -- Center widgets horizontally
                        wibox.widget {
                            nil,
                            arc_widget_containers,
                            nil,
                            expand = 'outer',
                            layout = wibox.layout.align.vertical
                        },
                        desktop_widgets_clock_container,
                        desktop_widgets_weather_container,
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
    end
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

    s.wibar_widget_containers = {layout = wibox.layout.fixed.horizontal}
    s.registered_wibar_widgets = {}
    for i, w in pairs(config.wibar_widgets) do
        local midx = #theme.widgets.wibar
        local cidx = (i - 1) % midx + 1
        local warg = config.widgets_arg[w] or
                         config.widgets_arg[gears.string.split(w, '_')[1]] or
                         {}
        warg = gears.table.clone(warg)
        warg.color = warg.color or theme.widgets.wibar[cidx]
        local widget_container, registered_widgets = wibar_widgets[w](warg)
        table.insert(s.wibar_widget_containers, widget_container)
        s.registered_wibar_widgets = gears.table.join(
                                         s.registered_wibar_widgets,
                                         registered_widgets
                                     )
    end
    table.insert(s.wibar_widget_containers, myexitmenu)

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
        -- Right widgets
        s.wibar_widget_containers
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
    s.unregister_widgets = function()
        if s.registered_wibar_widgets then
            for _, w in ipairs(s.registered_wibar_widgets) do
                vicious.unregister(w)
                gears.debug.print_warning('removed')
            end
            s.registered_wibar_widgets = nil
        end
        if s.registered_desktop_widgets then
            for _, w in ipairs(s.registered_desktop_widgets) do
                vicious.unregister(w)
                gears.debug.print_warning('removed')
            end
            s.registered_desktop_widgets = nil
        end
    end
    s.update_widgets = function()
        vicious.force(s.registered_wibar_widgets)
        if s.desktop_popup then
            vicious.force(s.registered_desktop_widgets)
        end
    end
    s.toggle_widgets = function()
        local opacity
        if s.widgets_suspeded then
            vicious.activate()
            s.widgets_suspeded = false
        else
            vicious.suspend()
            s.widgets_suspeded = true
        end
    end
    s.toggle_desktop_widget_visibility =
        function()
            if s.desktop_popup then
                local is_visible = s.desktop_popup.visible
                s.desktop_popup.visible = not is_visible
                if is_visible then
                    for _, w in ipairs(s.registered_desktop_widgets) do
                        vicious.unregister(w, true)
                    end
                else
                    for _, w in ipairs(s.registered_desktop_widgets) do
                        vicious.activate(w)
                    end
                end
            end
        end
    s.reset = function()
        s.unregister_widgets()

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
            if not config.tyrannical then
                awful.tag(
                    awful.util.tagnames, s,
                    awful.layout.default[s.index] or awful.layout.layouts[1]
                )
            end
        end
        collectgarbage()
    end

    s.mybottomwibar:connect_signal('mouse::enter', s.systray_set_screen)
    s:connect_signal('removed', s.reset)

    s.update_widgets()
end

theme.set_dark = function(self) self:set_color_scheme(color_schemes.dark) end

theme.set_light = function(self) self:set_color_scheme(color_schemes.light) end

theme.set_mirage =
    function(self) self:set_color_scheme(color_schemes.mirage) end

-- [ sequential code ] ---------------------------------------------------------
local color_scheme
if config.xresources then
    color_scheme = color_schemes.xrdb()
else
    color_scheme = color_schemes[config.color_scheme]
end

theme:set_color_scheme(color_scheme)

-- [ return module ] -----------------------------------------------------------
return theme
