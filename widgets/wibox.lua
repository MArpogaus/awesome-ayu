--[[
     AYU Awesome WM wibar widgets

     inspired by Multicolor Awesome WM beutiful 2.0
     github.com/lcpz
--]]
local os = os

local gears     = require("gears")
local lain      = require("lain")
local wibox     = require("wibox")
local beautiful = require("beautiful")

local markup = lain.util.markup

--local theme = require("themes.ayu.ayu_theme")
--local ayu_colors = require("themes.ayu.ayu_colors")
local util = require("themes.ayu.util")

local city_id = 2658372

---[ clock ]--------------------------------------------------------------------
os.setlocale(os.getenv("LANG")) -- to localize the clock
local gen_datetime_widget = function (color_date, color_time)
    local clock_icon = util.fa_ico(color_date, '')
    local clock_widget = wibox.widget.textclock(markup(color_date, "%A %d %B ") .. markup(beautiful.fg_normal, ">") .. markup(color_time, " %H:%M "))
    clock_widget.font = beautiful.font
    local clock_wibox_widget = util.create_wibox_widget(
        color_date,
        clock_icon,
        clock_widget
    )

    -- popup calendar
    beautiful.cal = lain.widget.cal({
        attach_to = { clock_wibox_widget },
        notification_preset = {
            font = "xos4 Terminus 10",
            fg   = beautiful.fg_normal,
            bg   = beautiful.bg_normal
        }
    })

    return clock_wibox_widget
end


--[ Weather ]-------------------------------------------------------------------
local gen_weather_widget = function (color)
    local weather_icon = ''
    weather_widget = lain.widget.weather({
        city_id = city_id,
        notification_preset = { font = "xos4 Terminus 10", fg = beautiful.fg_normal },
        weather_na_markup = markup.fontfg(beautiful.font, color, "N/A "),
        settings = function()
            descr = weather_now["weather"][1]["description"]:lower()
            units = math.floor(weather_now["main"]["temp"])
            widget:set_markup(markup.fontfg(beautiful.font, color, descr .. " @ " .. units .. "°C "))
        end
    })
    beautiful.weather = weather_widget

    return util.create_wibox_widget(
        color,
        weather_icon,
        weather_widget
    )
end

-- / fs
--[[ commented because it needs Gio/Glib >= 2.54
local fsicon = wibox.widget.imagebox(beautiful.widget_fs)
beautiful.fs = lain.widget.fs({
    notification_preset = { font = "xos4 Terminus 10", fg = beautiful.fg_normal },
    settings  = function()
        widget:set_markup(markup.fontfg(beautiful.font, "#80d9d8", string.format("%.1f", fs_now["/"].used) .. "% "))
    end
})
--]]

-- Mail IMAP check
--[[ commented because it needs to be set before use
local mailicon = wibox.widget.imagebox()
beautiful.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            mailicon:set_image(beautiful.widget_mail)
            widget:set_markup(markup.fontfg(beautiful.font, "#cccccc", mailcount))
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

--[ CPU ]-----------------------------------------------------------------------
local gen_cpu_widget = function (color)
    local cpu_icon = ''
    local cpu_widget = lain.widget.cpu({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color, cpu_now.usage .. "% "))
        end
    })
    return util.create_wibox_widget(
        color,
        cpu_icon,
        cpu_widget
    )
end

--[ Coretemp ]------------------------------------------------------------------
local gen_temp_widget = function (color)
    local temp_icon = util.fa_ico(color, '')
    local temp_widget = lain.widget.temp({
        tempfile = '/sys/class/thermal/thermal_zone1/temp',
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color, coretemp_now .. "°C "))
        end
    })

    return util.create_wibox_widget(
        color,
        temp_icon,
        temp_widget
    )
end

--[ Battery ]-------------------------------------------------------------------
local gen_bat_widget = function (color)
    local fa_bat_icons = {
        '', -- fa-battery-0 (alias) [&#xf244;]
        '', -- fa-battery-1 (alias) [&#xf243;]
        '', -- fa-battery-2 (alias) [&#xf242;]
        '', -- fa-battery-3 (alias) [&#xf241;]
        '' -- fa-battery-4 (alias) [&#xf240;]
    }
    local bat_icon = lain.widget.bat({
        settings = function()
            if bat_now.ac_status == 1 then
                ico = ''
            else
                ico = fa_bat_icons[math.floor(bat_now.perc/25)+1]
            end

            widget:set_markup(markup.fontfg(beautiful.fa_font, color, ico))
        end
    })
    bat_icon.align  = 'center'
    bat_icon.valign = 'center'
    bat_icon.forced_width = beautiful.ico_width
    local bat_widget = lain.widget.bat({
        settings = function()
            local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc

            widget:set_markup(markup.fontfg(beautiful.font, color, perc))
        end
    })

    return util.create_wibox_widget(
        color,
        bat_icon,
        bat_widget
    )
end

--[ ALSA volume ]---------------------------------------------------------------
local gen_vol_widget = function (color)
    local fa_vol_icons = {
        '', -- fa-volume-off [&#xf026;]
        '', -- fa-volume-down [&#xf027;]
        '' -- fa-volume-up [&#xf028;] 
    }
    local vol_icon = lain.widget.alsa({
        settings = function()
            if volume_now.status == "off" then
                ico = fa_vol_icons[1]
            else
                ico = fa_vol_icons[math.floor(volume_now.level/50)+2 % 4]
            end
            widget:set_markup(markup.fontfg(beautiful.fa_font, color, ico))
        end
    })
    vol_icon.align  = 'center'
    vol_icon.valign = 'center'
    vol_icon.forced_width = beautiful.ico_width
    vol_widget = lain.widget.alsa({
        settings = function()
            if volume_now.status == "off" then
                volume_now.level = "M"
            end

            widget:set_markup(markup.fontfg(beautiful.font, color, volume_now.level .. "%"))
        end
    })

    beautiful.volume = vol_widget


    return util.create_wibox_widget(
        color,
        vol_icon,
        vol_widget
    )
end

--[ Net ]-----------------------------------------------------------------------
local gen_netdown_widget = function (color)
    local netdown_icon = util.fa_ico(color, '')
    local netdown_widget = lain.widget.net({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color, net_now.received))
        end
    })

    return util.create_wibox_widget(
        color,
        netdown_icon,
        netdown_widget
    )
end

local gen_netup_widget = function (color)
    local netup_icon = util.fa_ico(color, '')
    local netup_widget = lain.widget.net({
        settings = function()
            if iface ~= "network off" and
               string.match(beautiful.weather.widget.text, "N/A")
            then
                beautiful.weather.update()
            end

            widget:set_markup(markup.fontfg(beautiful.font, color, net_now.sent))
        end
    })

    return util.create_wibox_widget(
        color,
        netup_icon,
        netup_widget
    )
end

--[ MEM ]-----------------------------------------------------------------------
local gen_mem_widget = function (color)
    local mem_icon = util.fa_ico(color, '')
    local mem_widget = lain.widget.mem({
        settings = function()
            widget:set_markup(markup.fontfg(beautiful.font, color, mem_now.used .. "M "))
        end
    })

    return util.create_wibox_widget(
        color,
        mem_icon,
        mem_widget
    )
end

--[ MPD ]-----------------------------------------------------------------------
local mpdicon = wibox.widget.imagebox()
beautiful.mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title
            mpdicon:set_image(beautiful.widget_note_on)
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
        widget:set_markup(markup.fontfg(beautiful.font, "#e54c62", artist) .. markup.fontfg(beautiful.font, "#b2b2b2", title))
    end
})

local module = {
    layout = wibox.layout.fixed.horizontal,
    wibox.widget.systray(),
    gen_netdown_widget(beautiful.widget_colors.netdown),
    gen_netup_widget(beautiful.widget_colors.netup),
    gen_vol_widget(beautiful.widget_colors.volume),
    gen_mem_widget(beautiful.widget_colors.memory), 
    gen_cpu_widget(beautiful.widget_colors.cpu), 
    gen_weather_widget(beautiful.widget_colors.weather), 
    gen_temp_widget(beautiful.widget_colors.temp), 
    gen_bat_widget(beautiful.widget_colors.bat), 
    gen_datetime_widget(beautiful.widget_colors.cal, beautiful.widget_colors.clock), 
}

return module