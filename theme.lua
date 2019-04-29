--[[
     AYU Awesome WM theme 0.1

     inspired by Multicolor Awesome WM theme 2.0
     github.com/lcpz
--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = require("themes.ayu.ayu_theme")
local ayu_colors = require("themes.ayu.ayu_colors")
local util = require("themes.ayu.util")

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "HighContrast"
local city_id = 2658372
-- set the wallpaper
--theme.wallpaper  = theme.confdir .. "/wall.png"

local markup = lain.util.markup

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local fa_ico = function(col, ico)
    return wibox.widget{
        markup = markup.fontfg(theme.fa_font, col, ico),
        widget = wibox.widget.textbox,
        align  = 'center',
        valign = 'center',
        forced_width = theme.ico_width
    }
end
-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clockicon = fa_ico(theme.widget_colors.cal, '')
local mytextclock = wibox.widget.textclock(markup(theme.widget_colors.cal, "%A %d %B ") .. markup(theme.fg_normal, ">") .. markup(theme.widget_colors.clock, " %H:%M "))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "xos4 Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Weather
local weathericon = fa_ico(theme.widget_colors.weather, '')
theme.weather = lain.widget.weather({
    city_id = city_id,
    notification_preset = { font = "xos4 Terminus 10", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, theme.widget_colors.weather, "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.weather, descr .. " @ " .. units .. "°C "))
    end
})

-- / fs
--[[ commented because it needs Gio/Glib >= 2.54
local fsicon = wibox.widget.imagebox(theme.widget_fs)
theme.fs = lain.widget.fs({
    notification_preset = { font = "xos4 Terminus 10", fg = theme.fg_normal },
    settings  = function()
        widget:set_markup(markup.fontfg(theme.font, "#80d9d8", string.format("%.1f", fs_now["/"].used) .. "% "))
    end
})
--]]

-- Mail IMAP check
--[[ commented because it needs to be set before use
local mailicon = wibox.widget.imagebox()
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            mailicon:set_image(theme.widget_mail)
            widget:set_markup(markup.fontfg(theme.font, "#cccccc", mailcount .. " "))
        else
            widget:set_text("")
            --mailicon:set_image() -- not working in 4.0
            mailicon._private.image = nil
            mailicon:emit_signal("widget::redraw_needed")
            mailicon:emit_signal("widget::layout_changed")
        end
    end
})
--]]

-- CPU
local cpu_ico = ''
local cpu_widget = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.cpu, cpu_now.usage .. "% "))
    end
}).widget
local cpu_wibox = util.create_wibox_widget(
    theme.widget_colors.cpu,
    cpu_ico,
    cpu_widget
)

-- Coretemp
local tempicon = fa_ico(theme.widget_colors.temp, '')
local temp = lain.widget.temp({
    tempfile = '/sys/class/thermal/thermal_zone1/temp',
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.temp, coretemp_now .. "°C "))
    end
})

-- Battery
local fa_bat_icons = {
    '', -- fa-battery-0 (alias) [&#xf244;]
    '', -- fa-battery-1 (alias) [&#xf243;]
    '', -- fa-battery-2 (alias) [&#xf242;]
    '', -- fa-battery-3 (alias) [&#xf241;]
    '' -- fa-battery-4 (alias) [&#xf240;]
}
local baticon = lain.widget.bat({
    settings = function()
        if bat_now.ac_status == 1 then
            ico = ''
        else
            ico = fa_bat_icons[math.floor(bat_now.perc/25)+1]
        end

        widget:set_markup(markup.fontfg(theme.fa_font, theme.widget_colors.bat, ico))
    end
})
baticon.align  = 'center'
baticon.valign = 'center'
baticon.forced_width = theme.ico_width
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.bat, perc .. " "))
    end
})

-- ALSA volume
-- Battery
local fa_vol_icons = {
    '', -- fa-volume-off [&#xf026;]
    '', -- fa-volume-down [&#xf027;]
    '' -- fa-volume-up [&#xf028;] 
}
local volicon = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            ico = fa_vol_icons[1]
        else
            ico = fa_vol_icons[math.floor(volume_now.level/50)+2 % 4]
        end
        widget:set_markup(markup.fontfg(theme.fa_font, theme.widget_colors.volume, ico))
    end
})
volicon.align  = 'center'
volicon.valign = 'center'
volicon.forced_width = theme.ico_width
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = "M"
        end

        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.volume, volume_now.level .. "% "))
    end
})

-- Net
local netdownicon = fa_ico(theme.widget_colors.netdown, '')
local netdowninfo = wibox.widget.textbox()
local netupicon = fa_ico(theme.widget_colors.netup, '')
local netupinfo = lain.widget.net({
    settings = function()
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end

        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.netup, net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(theme.font, theme.widget_colors.netdown, net_now.received .. " "))
    end
})

-- MEM
local memicon = fa_ico(theme.widget_colors.memory, '')
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, theme.widget_colors.memory, mem_now.used .. "M "))
    end
})

-- MPD
local mpdicon = wibox.widget.imagebox()
theme.mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            mpdicon:set_image(theme.widget_note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            --mpdicon:set_image() -- not working in 4.0
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end
        widget:set_markup(markup.fontfg(theme.font, "#e54c62", artist) .. markup.fontfg(theme.font, "#b2b2b2", title))
    end
})


function theme.at_screen_connect(s)
    -- Quake application
    if not s.quake then
        s.quake = lain.util.quake({ app = awful.util.terminal })
    end

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)


    -- Create a promptbox for each screen
    if not s.promptbox then
        s.mypromptbox = awful.widget.prompt()
    end
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    if not s.mylayoutbox then
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(my_table.join(
                               awful.button({}, 1, function () awful.layout.inc( 1) end),
                               awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                               awful.button({}, 3, function () awful.layout.inc(-1) end),
                               awful.button({}, 4, function () awful.layout.inc( 1) end),
                               awful.button({}, 5, function () awful.layout.inc(-1) end)))
    end
    -- Create a taglist widget
    if not s.mytaglist then
        awful.tag(awful.util.tagnames, s, awful.layout.layouts)
        s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)
    end
    -- Create a tasklist widget
    if not s.mytasklist then
        s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)
    end

    -- Create the wibox
    if s.mywibox then s.mywibox:remove() end
    s.mywibox = awful.wibar({ position = "top", screen = s, height = theme.top_bar_height, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
            mpdicon,
            theme.mpd.widget,
        },
        --s.mytasklist, -- Middle widget
        nil,
        -- { -- Right widgets
        --     layout = wibox.layout.fixed.horizontal,
        --     wibox.widget.systray(),
        --     --mailicon,
        --     --theme.mail.widget,
        --     netdownicon,
        --     netdowninfo,
        --     netupicon,
        --     netupinfo.widget,
        --     volicon,
        --     theme.volume.widget,
        --     memicon,
        --     memory.widget,
        --     --cpuicon,
        --     --cpu.widget,
        --     cpu_wibox,
        --     --fsicon,
        --     --theme.fs.widget,
        --     weathericon,
        --     theme.weather.widget,
        --     tempicon,
        --     temp.widget,
        --     baticon,
        --     bat.widget,
        --     clockicon,
        --     mytextclock,
        -- },
        require("themes.ayu.widgets.wibox")
    }

    -- Create the bottom wibox
    if s.mybottomwibox then s.mybottomwibox:remove() end
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = theme.bottom_bar_height, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
        },
    }

    deskop_clock = wibox.widget.textclock(
        markup.fontfg("xos4 Terminus "..dpi(48),"#FFFFFF", " %H:%M ")
    )
    deskop_clock_box = util.create_boxed_widget(deskop_clock, 420, 180, theme.widget_colors.desktop_clock)

    desktop_date = wibox.widget.textclock(
        markup.fontfg("xos4 Terminus "..dpi(18), theme.fg_normal, "Today is ") ..
        markup.fontfg("xos4 Terminus "..dpi(18), theme.widget_colors.desktop_day, "%A") ..
        markup.fontfg("xos4 Terminus "..dpi(18), theme.fg_normal, ", ") ..
        markup.fontfg("xos4 Terminus "..dpi(18), theme.widget_colors.desktop_date, "%d. %B") ..
        markup.fontfg("xos4 Terminus "..dpi(18), theme.fg_normal, " and there is "))

    desktop_weather = lain.widget.weather({
        city_id = city_id,
        weather_na_markup = markup.fontfg("xos4 Terminus "..dpi(18), theme.widget_colors.desktop_weather, "no forecast available"),
        settings = function()
            descr = weather_now["weather"][1]["description"]:lower()
            units = math.floor(weather_now["main"]["temp"])
            widget:set_markup(markup.fontfg("xos4 Terminus "..dpi(18), theme.widget_colors.desktop_weather, descr) .. markup.fontfg("xos4 Terminus "..dpi(18), theme.fg_normal, "."))
        end
    })

    s.desktop_widget = wibox({
        x = s.workarea.x,
        y = s.workarea.y,
        screen = s,
        visible = true,
        ontop = false,
        width = s.workarea.width,
        height = s.workarea.height,
        --fg = theme.fg_normal
    })
    s.desktop_widget:setup{
        -- Center widgets vertically
        nil,
        {
            -- Center widgets horizontally
            nil,
            {
                {
                    nil,
                    deskop_clock_box,
                    nil,
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                {
                    desktop_date,
                    desktop_weather,
                    expand = "none",
                    layout = wibox.layout.fixed.horizontal
                },
                expand = "none",
                layout = wibox.layout.fixed.vertical
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.vertical
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
end

theme.set_dark = function(self)
    self:set_color_scheme(ayu_colors.dark)
end

theme.set_light = function(self)
    self:set_color_scheme(ayu_colors.light)
end

theme.set_mirage = function(self)
    self:set_color_scheme(ayu_colors.mirage)
end

return theme
