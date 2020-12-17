--------------------------------------------------------------------------------
-- @File:   theme.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-30 20:36:28
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-06 12:22:15
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
local table = table

local capi = {client = client}

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
    -- Each screen has its own tag table.
    if not s.mytaglist then
        awful.tag(
            awful.util.tagnames, s,
            awful.layout.default[s.index] or awful.layout.layouts[1]
        )
    end

    if s.reset then s.reset() end

    if config.dpi then s.dpi = config.dpi end

    -- If wallpaper is a function, call it with the screen
    local wallpaper = config.wallpaper or theme.wallpaper
    if type(wallpaper) == 'function' then
        gears.wallpaper.maximized(wallpaper(s), s, true)
    elseif wallpaper == 'xfconf-query' then
        local command =
            'xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path'
        awful.spawn.easy_async_with_shell(
            command,
            function(stdout, stderr, reason, exit_code) -- luacheck: no unused args
                if exit_code == 0 then
                    local file_name = string.gsub(stdout, '\n', '')
                    gears.wallpaper.maximized(file_name, s, true)
                else
                    gears.wallpaper.maximized(theme.wallpaper(s), s, true)
                end
            end
        )
    else
        gears.wallpaper.maximized(wallpaper, s, true)
    end

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
        buttons = awful.util.tasklist_buttons,
        layout = {
            spacing = theme.systray_icon_spacing,
            layout = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 5,
                id = 'clientstack',
                widget = wibox.container.background
            },
            {
                nil,
                {id = 'clienticon', widget = awful.widget.clienticon},
                nil,
                expand = 'none',
                id = 'clienticoncontainer',
                widget = wibox.layout.align.horizontal
            },
            nil,
            create_callback = function(self, c, index, objects) -- luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            update_callback = function(self, c, index, objects) -- luacheck: no unused args
                if c.multiple_instances and c.multiple_instances > 1 then
                    self:get_children_by_id('clientstack')[1].bg =
                        theme.fg_normal
                else
                    self:get_children_by_id('clientstack')[1].bg =
                        theme.bg_normal
                end
                if capi.client.focus and capi.client.focus.class == c.class then
                    self:get_children_by_id('clienticoncontainer')[1].opacity =
                        1
                else
                    self:get_children_by_id('clienticoncontainer')[1].opacity =
                        0.5
                end
                self:emit_signal('widget::redraw_needed')
            end,
            layout = wibox.layout.align.vertical
        },
        source = function()
            -- Get all clients
            local cls = capi.client.get()

            -- Filter by an existing filter function and allowing only one client per class
            local clients = {}
            local class_seen = {}
            for _, c in pairs(cls) do
                if awful.widget.tasklist.filter.currenttags(c, s) then
                    if not class_seen[c.class] then
                        class_seen[c.class] = 1
                        clients[c.class] = c
                    else
                        class_seen[c.class] = class_seen[c.class] + 1
                    end
                    clients[c.class].multiple_instances = class_seen[c.class]
                end
            end
            local ret = {}
            for _, v in pairs(clients) do table.insert(ret, v) end
            return ret
        end
    }

    -- Create the desktop widget popup
    local arc_widget_containers = {
        spacing = theme.desktop_widgets_arc_spacing,
        layout = wibox.layout.fixed.horizontal
    }
    s.registered_desktop_widgets = {}
    for i, w in pairs(config.arc_widgets) do
        local midx = #theme.widgets.desktop.arcs
        local cidx = (i - 1) % midx + 1
        local color = theme.widgets.desktop.arcs[cidx]
        local fg_color = util.reduce_contrast(color, 50)
        local bg_color = util.set_alpha(fg_color, 50)
        local warg = config.widgets_arg[w] or
                         config.widgets_arg[gears.string.split(w, '_')[1]] or
                         {}
        warg = gears.table.clone(warg)
        warg.fg_color = warg.fg_color or fg_color
        warg.bg_color = warg.bg_color or bg_color
        local widget_container, registered_widgets =
            desktop_widgets.arcs[w](warg)
        table.insert(arc_widget_containers, widget_container)
        s.registered_desktop_widgets = gears.table.join(
                                           s.registered_desktop_widgets,
                                           registered_widgets
                                       )
    end
    local desktop_widgets_clock_container, desktop_widgets_clock_widgets =
        desktop_widgets.clock()
    local desktop_widgets_weather_container, desktop_widgets_weather_widgets =
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

    local desktop_popup_widget = wibox.widget {
        {
            -- Align widgets vertically
            arc_widget_containers,
            {
                desktop_widgets_clock_container,
                widget = wibox.container.margin,
                top = theme.desktop_widgets_vertical_spacing,
                bottom = theme.desktop_widgets_vertical_spacing
            },
            desktop_widgets_weather_container,
            layout = wibox.layout.align.vertical
        },
        widget = wibox.container.margin,
        margins = theme.desktop_widgets_vertical_spacing / 2
    }
    local desktop_popup_arg = {
        widget = desktop_popup_widget,
        type = 'desktop',
        screen = s,
        placement = awful.placement.centered,
        visible = false,
        input_passthrough = true
    }
    if config.wallpaper then
        desktop_popup_arg.border_color = theme.fg_normal
        desktop_popup_arg.border_width = theme.border_width
        desktop_popup_arg.bg = util.set_alpha(theme.bg_normal, 75)
    end

    s.desktop_popup = awful.popup(desktop_popup_arg)
    s.desktop_popup:connect_signal(
        'property::visible', function()
            if s.desktop_popup.visible then
                s.activate_desktop_widgets()
            else
                s.suspend_desktop_widgets()
            end
        end
    )

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
            end
            s.registered_wibar_widgets = nil
        end
        if s.registered_desktop_widgets then
            for _, w in ipairs(s.registered_desktop_widgets) do
                vicious.unregister(w)
            end
            s.registered_desktop_widgets = nil
        end
    end
    s.update_widgets = function()
        vicious.force(s.registered_wibar_widgets)
        vicious.force(s.registered_desktop_widgets)
    end
    s.toggle_widgets = function()
        local wibar_widgets_opacity
        local desktop_popup_visible
        if s.widgets_suspeded then
            vicious.activate()
            s.widgets_suspeded = false
            desktop_popup_visible = true
            wibar_widgets_opacity = 1
        else
            vicious.suspend()
            s.widgets_suspeded = true
            desktop_popup_visible = false
            wibar_widgets_opacity = 0.5
        end
        s.desktop_popup.visible = desktop_popup_visible
        for _, w in ipairs(s.wibar_widget_containers) do
            if w.has_registered_widgets then
                w.opacity = wibar_widgets_opacity
                w:emit_signal('widget::redraw_needed')
            end
        end
    end
    s.toggle_widgets = function()
        local wibar_widgets_opacity
        local desktop_popup_visible
        if s.widgets_suspeded then
            vicious.activate()
            s.widgets_suspeded = false
            desktop_popup_visible = true
            wibar_widgets_opacity = 1
        else
            vicious.suspend()
            s.widgets_suspeded = true
            desktop_popup_visible = false
            wibar_widgets_opacity = 0.5
        end
        s.desktop_popup.visible = desktop_popup_visible
        for _, w in ipairs(s.wibar_widget_containers) do
            if w.has_registered_widgets then
                w.opacity = wibar_widgets_opacity
                w:emit_signal('widget::redraw_needed')
            end
        end
    end
    s.toggle_desktop_widget_visibility =
        function()
            if s.desktop_popup then
                local is_visible = s.desktop_popup.visible
                s.desktop_popup.visible = not is_visible
            end
        end
    s.suspend_desktop_widgets = function()
        for _, w in ipairs(s.registered_desktop_widgets) do
            vicious.unregister(w, true)
        end
    end
    s.activate_desktop_widgets = function()
        for _, w in ipairs(s.registered_desktop_widgets) do
            vicious.activate(w)
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
        end
        collectgarbage()
    end

    s.mybottomwibar:connect_signal('mouse::enter', s.systray_set_screen)
    s:connect_signal('removed', s.reset)

    -- show hide desktop_popup
    s.desktop_popup.visible = config.desktop_widgets

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
