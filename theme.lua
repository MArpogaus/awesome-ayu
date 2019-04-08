--[[
     AYU Awesome WM theme 0.1

     inspired by Multicolor Awesome WM theme 2.0
     github.com/lcpz
--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local cairo = require("lgi").cairo

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

local ayu = require("themes.ayu.ayu")

local color_scheme = ayu.colors.light
ayu.ui:set_color_scheme(color_scheme)

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme = {}

theme.confdir                  = config_path .. "/themes/ayu"
theme.wallpaper                = theme.confdir .. "/wall.png"
theme.font                     = "xos4 Terminus " .. dpi(8)
theme.fa_font                  = "FontAwesome " .. dpi(8)
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon    = true
theme.useless_gap              = 0
theme.ico_width                = dpi(20)
theme.button_size              = dpi(32)
theme.button_radius            = dpi(10)
theme.menu_bg_normal           = color_scheme.bg
theme.menu_bg_focus            = color_scheme.bg
theme.bg_normal                = color_scheme.bg
theme.bg_focus                 = color_scheme.bg
theme.bg_urgent                = color_scheme.bg
theme.fg_normal                = color_scheme.fg
theme.fg_focus                 = color_scheme.accent
theme.fg_urgent                = color_scheme.error
theme.fg_minimize              = color_scheme.fg
theme.border_width             = 1
theme.border_normal            = color_scheme.fg
theme.border_focus             = color_scheme.fg
theme.border_marked            = color_scheme.accent
theme.top_bar_height           = dpi(20)
theme.bottom_bar_height        = dpi(20)
theme.menu_border_width        = 0
theme.menu_submenu_icon        = themes_path.."default/submenu.png"
theme.menu_height              = dpi(15)
theme.menu_width               = dpi(150)
theme.menu_fg_normal           = color_scheme.fg
theme.menu_fg_focus            = color_scheme.accent
theme.menu_bg_normal           = color_scheme.bg
theme.menu_bg_focus            = color_scheme.bg

theme.titlebar_close_button_normal                    = ayu.ui:close_button(theme.button_size, theme.button_radius, false)
theme.titlebar_close_button_focus                     = ayu.ui:close_button(theme.button_size, theme.button_radius, false)
theme.titlebar_close_button_normal_hover              = ayu.ui:close_button(theme.button_size, theme.button_radius, true)
theme.titlebar_close_button_focus_hover               = ayu.ui:close_button(theme.button_size, theme.button_radius, true)

theme.titlebar_minimize_button_normal                 = ayu.ui:minimize_button(theme.button_size, theme.button_radius, false)
theme.titlebar_minimize_button_focus                  = ayu.ui:minimize_button(theme.button_size, theme.button_radius, false)
theme.titlebar_minimize_button_normal_hover           = ayu.ui:minimize_button(theme.button_size, theme.button_radius, true)
theme.titlebar_minimize_button_focus_hover            = ayu.ui:minimize_button(theme.button_size, theme.button_radius, true)

theme.titlebar_maximized_button_normal_active         = ayu.ui:maximized_button(theme.button_size, theme.button_radius, false, true)
theme.titlebar_maximized_button_focus_active          = ayu.ui:maximized_button(theme.button_size, theme.button_radius, false, true)
theme.titlebar_maximized_button_normal_inactive       = ayu.ui:maximized_button(theme.button_size, theme.button_radius, false)
theme.titlebar_maximized_button_focus_inactive        = ayu.ui:maximized_button(theme.button_size, theme.button_radius, false)
theme.titlebar_maximized_button_normal_active_hover   = ayu.ui:maximized_button(theme.button_size, theme.button_radius, true)
theme.titlebar_maximized_button_focus_active_hover    = ayu.ui:maximized_button(theme.button_size, theme.button_radius, true)
theme.titlebar_maximized_button_normal_inactive_hover = ayu.ui:maximized_button(theme.button_size, theme.button_radius, true)
theme.titlebar_maximized_button_focus_inactive_hover  = ayu.ui:maximized_button(theme.button_size, theme.button_radius, true)

theme.titlebar_ontop_button_normal_active             = ayu.ui:ontop_button(theme.button_size, theme.button_radius, false, true)
theme.titlebar_ontop_button_focus_active              = ayu.ui:ontop_button(theme.button_size, theme.button_radius, false, true)
theme.titlebar_ontop_button_normal_inactive           = ayu.ui:ontop_button(theme.button_size, theme.button_radius, false)
theme.titlebar_ontop_button_focus_inactive            = ayu.ui:ontop_button(theme.button_size, theme.button_radius, false)
theme.titlebar_ontop_button_normal_active_hover       = ayu.ui:ontop_button(theme.button_size, theme.button_radius, true)
theme.titlebar_ontop_button_focus_active_hover        = ayu.ui:ontop_button(theme.button_size, theme.button_radius, true)
theme.titlebar_ontop_button_normal_inactive_hover     = ayu.ui:ontop_button(theme.button_size, theme.button_radius, true)
theme.titlebar_ontop_button_focus_inactive_hover      = ayu.ui:ontop_button(theme.button_size, theme.button_radius, true)

theme.titlebar_sticky_button_normal_active            = ayu.ui:sticky_button(theme.button_size, theme.button_radius, false, true)
theme.titlebar_sticky_button_focus_active             = ayu.ui:sticky_button(theme.button_size, theme.button_radius, false, true)
theme.titlebar_sticky_button_normal_inactive          = ayu.ui:sticky_button(theme.button_size, theme.button_radius, false)
theme.titlebar_sticky_button_focus_inactive           = ayu.ui:sticky_button(theme.button_size, theme.button_radius, false)
theme.titlebar_sticky_button_normal_active_hover      = ayu.ui:sticky_button(theme.button_size, theme.button_radius, true)
theme.titlebar_sticky_button_focus_active_hover       = ayu.ui:sticky_button(theme.button_size, theme.button_radius, true)
theme.titlebar_sticky_button_normal_inactive_hover    = ayu.ui:sticky_button(theme.button_size, theme.button_radius, true)
theme.titlebar_sticky_button_focus_inactive_hover     = ayu.ui:sticky_button(theme.button_size, theme.button_radius, true)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_focus
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Define the image to load
theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = themes_path.."default/titlebar/floating_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv      = themes_path.."default/layouts/fairvw.png"
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
theme.layout_max        = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "HighContrast"

local markup = lain.util.markup

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local fa_ico = function(col, ico)
    return wibox.widget{
        markup = markup.fontfg(theme.fa_font, col, ico),
        widget = wibox.widget.textbox,
        align  = 'center',
        valign = 'center',
        forced_width = theme.ico_width
    }
end
local clockicon = fa_ico(ayu.ui.widget_colors.cal, '')
local mytextclock = wibox.widget.textclock(markup(ayu.ui.widget_colors.cal, "%A %d %B ") .. markup(theme.fg_normal, ">") .. markup(ayu.ui.widget_colors.clock, " %H:%M "))
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
local weathericon = fa_ico(ayu.ui.widget_colors.weather, '')
theme.weather = lain.widget.weather({
    city_id = 2658372, -- placeholder (London)
    notification_preset = { font = "xos4 Terminus 10", fg = theme.fg_normal },
    weather_na_markup = markup.fontfg(theme.font, ayu.ui.widget_colors.weather, "N/A "),
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.weather, descr .. " @ " .. units .. "°C "))
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
local cpuicon = fa_ico(ayu.ui.widget_colors.cpu, '')
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.cpu, cpu_now.usage .. "% "))
    end
})

-- Coretemp
local tempicon = fa_ico(ayu.ui.widget_colors.temp, '')
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.temp, coretemp_now .. "°C "))
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
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        widget:set_markup(markup.fontfg(theme.fa_font, ayu.ui.widget_colors.bat, fa_bat_icons[math.floor(bat_now.perc/25)+1]))
    end
})
baticon.align  = 'center'
baticon.valign = 'center'
baticon.forced_width = theme.ico_width
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

        if bat_now.ac_status == 1 then
            perc = perc .. " plug"
        end

        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.bat, perc .. " "))
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
        widget:set_markup(markup.fontfg(theme.fa_font, ayu.ui.widget_colors.volume, ico))
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

        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.volume, volume_now.level .. "% "))
    end
})

-- Net
local netdownicon = fa_ico(ayu.ui.widget_colors.netdown, '')
local netdowninfo = wibox.widget.textbox()
local netupicon = fa_ico(ayu.ui.widget_colors.netup, '')
local netupinfo = lain.widget.net({
    settings = function()
        if iface ~= "network off" and
           string.match(theme.weather.widget.text, "N/A")
        then
            theme.weather.update()
        end

        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.netup, net_now.sent .. " "))
        netdowninfo:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.netdown, net_now.received .. " "))
    end
})

-- MEM
local memicon = fa_ico(ayu.ui.widget_colors.memory, '')
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, ayu.ui.widget_colors.memory, mem_now.used .. "M "))
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
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
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
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            --mailicon,
            --theme.mail.widget,
            netdownicon,
            netdowninfo,
            netupicon,
            netupinfo.widget,
            volicon,
            theme.volume.widget,
            memicon,
            memory.widget,
            cpuicon,
            cpu.widget,
            --fsicon,
            --theme.fs.widget,
            weathericon,
            theme.weather.widget,
            tempicon,
            temp.widget,
            baticon,
            bat.widget,
            clockicon,
            mytextclock,
        },
    }

    -- Create the bottom wibox
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
end

theme.set_dark = function()
    ayu.ui:set_color_scheme(ayu.colors.dark)
end

return theme
