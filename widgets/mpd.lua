--------------------------------------------------------------------------------
-- @File:   mpd.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- mpd widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:33:06
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-06-30 18:57:29
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local os = os

local lain = require("lain")
local wibox = require("wibox")
local beautiful = require("beautiful")
local markup = lain.util.markup

local util = require("themes.ayu.util")

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ function definitions ] ----------------------------------------------------
module.gen_wibar_widget = function()
    local mpd_icon = wibox.widget.textbox()
    mpd_widget = lain.widget.mpd({
        settings = function()
            mpd_notification_preset = {
                text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                                     mpd_now.album, mpd_now.date, mpd_now.title)
            }

            if mpd_now.state == "play" then
                artist = mpd_now.artist .. " > "
                title = mpd_now.title
                mpd_icon:set_markup(util.fa_markup(beautiful.widget_colors.mpd,
                                                   ''))
            elseif mpd_now.state == "pause" then
                artist = "mpd "
                title = "paused"
                mpd_icon:set_markup(util.fa_markup(beautiful.widget_colors.mpd,
                                                   ''))
            else
                artist = ""
                title = ""
                mpd_icon:set_markup("")
                mpd_icon:emit_signal("widget::redraw_needed")
                mpd_icon:emit_signal("widget::layout_changed")
            end
            widget:set_markup(markup.fontfg(beautiful.font, beautiful.fg_normal,
                                            artist .. title))
        end,
        notification_preset = {
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal
        }
    })
    beautiful.mpd = mpd_widget

    return util.create_wibar_widget(color, mpd_icon, mpd_widget)
end

-- [ return module objects ] ---------------------------------------------------
return module
