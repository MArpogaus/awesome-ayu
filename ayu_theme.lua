--------------------------------------------------------------------------------
-- @File:   ayu_theme.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-10-23 19:28:06
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-12-04 09:05:22
-- [ description ] -------------------------------------------------------------
-- factory to build a awesome theme based on a given colorscheme
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

local theme_assets = require('beautiful.theme_assets')

local gfs = require('gears.filesystem')
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}

-- [ module functions ] --------------------------------------------------------
module.set_color_scheme = function(self, cs)
    -- configure theme parameters
    self.titlebar_size = 30
    self.top_bar_height = self.titlebar_size
    self.bottom_bar_height = self.titlebar_size

    self.ico_width = self.titlebar_size
    self.icon_margin_left = 12
    self.icon_margin_right = 8
    self.systray_icon_spacing = self.icon_margin_left

    self.confdir = config_path .. '/themes/ayu/'

    self.font_name = 'mononoki '
    self.font_size = 10
    self.font = self.font_name .. self.font_size
    self.notification_font = self.font_name .. (2 * self.font_size)

    self.useless_gap = 0
    self.button_size = self.titlebar_size
    self.button_radius = 0.35 * self.titlebar_size
    self.menu_bg_normal = cs.bg
    self.menu_bg_focus = cs.bg
    self.bg_normal = cs.bg
    self.bg_focus = cs.bg
    self.bg_urgent = cs.bg
    self.fg_normal = cs.fg
    self.fg_focus = cs.colors[4]
    self.fg_urgent = cs.colors[2]
    self.fg_minimize = cs.fg
    self.border_width = 1
    self.border_normal = cs.fg
    self.border_focus = cs.colors[7]
    self.border_marked = cs.colors[4]
    self.menu_border_width = 0
    self.menu_height = 30
    self.menu_width = 200
    self.menu_fg_normal = cs.fg
    self.menu_fg_focus = cs.colors[4]
    self.menu_bg_normal = cs.bg
    self.menu_bg_focus = cs.bg

    -- self.tasklist_plain_task_name = true
    self.tasklist_bg_normal = self.bg_normal
    self.tasklist_bg_focus = self.fg_focus

    -- set colors for buttons and widgets
    self.exit_icon_bg_color = cs.bg -- "#F07171"
    self.close_button_bg_color = cs.colors[2] -- "#F07171"
    self.maximized_button_bg_color = cs.colors[3] -- "#91B362"
    self.minimize_button_bg_color = cs.colors[4] -- "#E6B450"
    self.ontop_button_bg_color = cs.colors[7] -- "#399EE6"
    self.sticky_button_bg_color = cs.colors[8] -- "#ABB0B6"

    self.exit_icon_fg_color = cs.fg
    self.close_button_fg_color = util.reduce_contrast(
                                     self.close_button_bg_color, 50
                                 )
    self.maximized_button_fg_color = util.reduce_contrast(
                                         self.maximized_button_bg_color, 50
                                     )
    self.minimize_button_fg_color = util.reduce_contrast(
                                        self.minimize_button_bg_color, 50
                                    )
    self.ontop_button_fg_color = util.reduce_contrast(
                                     self.ontop_button_bg_color, 50
                                 )
    self.sticky_button_fg_color = util.reduce_contrast(
                                      self.sticky_button_bg_color, 50
                                  )

    self.widgets = {
        wibar = {

            cs.colors[2],
            cs.colors[3],
            cs.colors[4],
            cs.colors[6],
            cs.colors[5],
            cs.colors[7],

            cs.colors[10],
            cs.colors[11],
            cs.colors[12],
            cs.colors[14],
            cs.colors[13],
            cs.colors[15],

            cal = cs.colors[16],
            clock = cs.colors[4]
        },
        desktop = {
            arcs = {
                cs.colors[2],
                cs.colors[3],
                cs.colors[4],
                cs.colors[5],
                cs.colors[6],
                cs.colors[7],
                cs.colors[10],
                cs.colors[11],
                cs.colors[12],
                cs.colors[14],
                cs.colors[13],
                cs.colors[15]
            },
            clock = {
                fg = self.fg_normal,
                bg = cs.colors[8 + 5],
                time = self.bg_normal,
                day = cs.colors[4],
                date = cs.colors[2],
                month = cs.colors[3]
            },
            weather = {fg = self.fg_normal}

        }
    }

    self.desktop_widgets_arc_size = 220
    self.desktop_widgets_arc_spacing = 110
    self.desktop_widgets_vertical_spacing = 170
    self.desktop_widgets_time_font_size = 50
    self.desktop_widgets_date_font_size =
        self.desktop_widgets_time_font_size / 3
    self.desktop_widgets_weather_font_size = 50

    -- generate buttons
    self.titlebar_close_button_normal =
        self:close_button(self.button_size, self.button_radius, false)
    self.titlebar_close_button_focus = self:close_button(
                                           self.button_size,
                                           self.button_radius, false
                                       )
    self.titlebar_close_button_normal_hover =
        self:close_button(self.button_size, self.button_radius, true)
    self.titlebar_close_button_focus_hover =
        self:close_button(self.button_size, self.button_radius, true)

    self.titlebar_minimize_button_normal =
        self:minimize_button(self.button_size, self.button_radius, false)
    self.titlebar_minimize_button_focus =
        self:minimize_button(self.button_size, self.button_radius, false)
    self.titlebar_minimize_button_normal_hover =
        self:minimize_button(self.button_size, self.button_radius, true)
    self.titlebar_minimize_button_focus_hover =
        self:minimize_button(self.button_size, self.button_radius, true)

    self.titlebar_maximized_button_normal_active =
        self:maximized_button(self.button_size, self.button_radius, false, true)
    self.titlebar_maximized_button_focus_active =
        self:maximized_button(self.button_size, self.button_radius, false, true)
    self.titlebar_maximized_button_normal_inactive =
        self:maximized_button(self.button_size, self.button_radius, false)
    self.titlebar_maximized_button_focus_inactive =
        self:maximized_button(self.button_size, self.button_radius, false)
    self.titlebar_maximized_button_normal_active_hover =
        self:maximized_button(self.button_size, self.button_radius, true)
    self.titlebar_maximized_button_focus_active_hover =
        self:maximized_button(self.button_size, self.button_radius, true)
    self.titlebar_maximized_button_normal_inactive_hover =
        self:maximized_button(self.button_size, self.button_radius, true)
    self.titlebar_maximized_button_focus_inactive_hover =
        self:maximized_button(self.button_size, self.button_radius, true)

    self.titlebar_ontop_button_normal_active =
        self:ontop_button(self.button_size, self.button_radius, false, true)
    self.titlebar_ontop_button_focus_active =
        self:ontop_button(self.button_size, self.button_radius, false, true)
    self.titlebar_ontop_button_normal_inactive =
        self:ontop_button(self.button_size, self.button_radius, false)
    self.titlebar_ontop_button_focus_inactive =
        self:ontop_button(self.button_size, self.button_radius, false)
    self.titlebar_ontop_button_normal_active_hover =
        self:ontop_button(self.button_size, self.button_radius, true)
    self.titlebar_ontop_button_focus_active_hover =
        self:ontop_button(self.button_size, self.button_radius, true)
    self.titlebar_ontop_button_normal_inactive_hover =
        self:ontop_button(self.button_size, self.button_radius, true)
    self.titlebar_ontop_button_focus_inactive_hover =
        self:ontop_button(self.button_size, self.button_radius, true)

    self.titlebar_sticky_button_normal_active =
        self:sticky_button(self.button_size, self.button_radius, false, true)
    self.titlebar_sticky_button_focus_active =
        self:sticky_button(self.button_size, self.button_radius, false, true)
    self.titlebar_sticky_button_normal_inactive =
        self:sticky_button(self.button_size, self.button_radius, false)
    self.titlebar_sticky_button_focus_inactive =
        self:sticky_button(self.button_size, self.button_radius, false)
    self.titlebar_sticky_button_normal_active_hover =
        self:sticky_button(self.button_size, self.button_radius, true)
    self.titlebar_sticky_button_focus_active_hover =
        self:sticky_button(self.button_size, self.button_radius, true)
    self.titlebar_sticky_button_normal_inactive_hover =
        self:sticky_button(self.button_size, self.button_radius, true)
    self.titlebar_sticky_button_focus_inactive_hover =
        self:sticky_button(self.button_size, self.button_radius, true)

    -- Generate taglist squares:
    local taglist_square_size = 4
    self.taglist_squares_sel = theme_assets.taglist_squares_sel(
                                   taglist_square_size, self.fg_focus
                               )
    self.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
                                     taglist_square_size, self.fg_normal
                                 )
    if util.is_dark(cs.bg) then
        self.titlebar_floating_button_normal_inactive =
            themes_path .. 'default/titlebar/floating_normal_inactive.png'
        self.titlebar_floating_button_focus_inactive =
            themes_path .. 'default/titlebar/floating_normal_inactive.png'
        self.titlebar_floating_button_normal_active =
            themes_path .. 'default/titlebar/floating_normal_active.png'
        self.titlebar_floating_button_focus_active =
            themes_path .. 'default/titlebar/floating_normal_active.png'

        self.layout_fairh = themes_path .. 'default/layouts/fairhw.png'
        self.layout_fairv = themes_path .. 'default/layouts/fairvw.png'
        self.layout_floating = themes_path .. 'default/layouts/floatingw.png'
        self.layout_magnifier = themes_path .. 'default/layouts/magnifierw.png'
        self.layout_max = themes_path .. 'default/layouts/maxw.png'
        self.layout_fullscreen = themes_path ..
                                     'default/layouts/fullscreenw.png'
        self.layout_tilebottom = themes_path ..
                                     'default/layouts/tilebottomw.png'
        self.layout_tileleft = themes_path .. 'default/layouts/tileleftw.png'
        self.layout_tile = themes_path .. 'default/layouts/tilew.png'
        self.layout_tiletop = themes_path .. 'default/layouts/tiletopw.png'
        self.layout_spiral = themes_path .. 'default/layouts/spiralw.png'
        self.layout_dwindle = themes_path .. 'default/layouts/dwindlew.png'
        self.layout_cornernw = themes_path .. 'default/layouts/cornernww.png'
        self.layout_cornerne = themes_path .. 'default/layouts/cornernew.png'
        self.layout_cornersw = themes_path .. 'default/layouts/cornersww.png'
        self.layout_cornerse = themes_path .. 'default/layouts/cornersew.png'

    else
        self.titlebar_floating_button_normal_inactive =
            themes_path .. 'default/titlebar/floating_focus_inactive.png'
        self.titlebar_floating_button_focus_inactive =
            themes_path .. 'default/titlebar/floating_focus_inactive.png'
        self.titlebar_floating_button_normal_active =
            themes_path .. 'default/titlebar/floating_focus_active.png'
        self.titlebar_floating_button_focus_active =
            themes_path .. 'default/titlebar/floating_focus_active.png'

        self.layout_fairh = themes_path .. 'default/layouts/fairh.png'
        self.layout_fairv = themes_path .. 'default/layouts/fairv.png'
        self.layout_floating = themes_path .. 'default/layouts/floating.png'
        self.layout_magnifier = themes_path .. 'default/layouts/magnifier.png'
        self.layout_max = themes_path .. 'default/layouts/max.png'
        self.layout_fullscreen = themes_path ..
                                     'default/layouts/fullscreen.png'
        self.layout_tilebottom = themes_path ..
                                     'default/layouts/tilebottom.png'
        self.layout_tileleft = themes_path .. 'default/layouts/tileleft.png'
        self.layout_tile = themes_path .. 'default/layouts/tile.png'
        self.layout_tiletop = themes_path .. 'default/layouts/tiletop.png'
        self.layout_spiral = themes_path .. 'default/layouts/spiral.png'
        self.layout_dwindle = themes_path .. 'default/layouts/dwindle.png'
        self.layout_cornernw = themes_path .. 'default/layouts/cornernw.png'
        self.layout_cornerne = themes_path .. 'default/layouts/cornerne.png'
        self.layout_cornersw = themes_path .. 'default/layouts/cornersw.png'
        self.layout_cornerse = themes_path .. 'default/layouts/cornerse.png'

    end

    -- Generate Awesome icon:
    self.awesome_icon = theme_assets.awesome_icon(
                            self.menu_height, self.fg_normal, self.bg_normal
                        )
    self.exitmenu_icon = self:exit_icon(
                             self.menu_height * 2, self.menu_height / 2
                         )

    -- wallpaper
    self.wallpaper = function(s)
        return gears.surface.load_from_shape(
                   s.geometry.width, s.geometry.height, gears.shape.rectangle,
                   cs.bg
               )
    end
end
module.exit_icon = function(self, size, radius)
    local bg_color = self.exit_icon_bg_color
    local fg_color = self.exit_icon_fg_color
    local img, cr = util.titlebar_button(size, radius, bg_color, fg_color, 2)

    -- draw content
    local active_color = self.exit_icon_fg_color
    cr:set_source(gears.color(active_color))
    local width = radius / 4
    local height = radius
    local x = (size - width) / 2
    local y = (size - height) / 2
    local shape = gears.shape.transform(gears.shape.rectangle):translate(x, y)
    shape(cr, width, height)
    cr:fill()

    return img
end
module.close_button = function(self, size, radius, hover, active)
    local bg_color = self.close_button_bg_color
    local fg_color
    if hover then
        fg_color = self.close_button_fg_color
    else
        fg_color = self.close_button_bg_color
    end
    local img, cr = util.titlebar_button(size, radius, bg_color, fg_color)

    -- draw content
    if active or hover then
        cr:set_source(gears.color(self.close_button_fg_color))
        local width = 1.5 * radius
        local height = 1.5 * radius
        local thickness = width / 4
        local x = size / 2
        local y = (size - height - width / 3) / 2
        local shape = gears.shape.transform(gears.shape.cross):translate(x, y)
                          :rotate(math.pi / 4)
        shape(cr, width, height, thickness)
        cr:fill()
    end

    return img
end
module.maximized_button = function(self, size, radius, hover, active)
    local bg_color = self.maximized_button_bg_color
    local fg_color
    if hover then
        fg_color = self.maximized_button_fg_color
    else
        fg_color = self.maximized_button_bg_color
    end
    local img, cr = util.titlebar_button(size, radius, bg_color, fg_color)

    -- draw content
    local active_color
    if active or hover then
        active_color = self.maximized_button_fg_color
    else
        active_color = self.maximized_button_bg_color
    end
    cr:set_source(gears.color(active_color))
    local width = 1.5 * radius
    local height = 1.5 * radius
    local thickness = width / 4
    local x = (size - height) / 2
    local y = (size - height) / 2
    local shape = gears.shape.transform(gears.shape.cross):translate(x, y)
    shape(cr, width, height, thickness)
    cr:fill()

    return img
end
module.minimize_button = function(self, size, radius, hover, active)
    local bg_color = self.minimize_button_bg_color
    local fg_color
    if hover then
        fg_color = self.minimize_button_fg_color
    else
        fg_color = self.minimize_button_bg_color
    end
    local img, cr = util.titlebar_button(size, radius, bg_color, fg_color)

    -- draw content
    local active_color
    if active or hover then
        active_color = self.minimize_button_fg_color
    else
        active_color = self.minimize_button_bg_color
    end
    cr:set_source(gears.color(active_color))
    local width = radius
    local height = radius / 4
    local x = (size - width) / 2
    local y = (size - height) / 2
    local shape = gears.shape.transform(gears.shape.rectangle):translate(x, y)
    shape(cr, width, height)
    cr:fill()

    return img
end
module.ontop_button = function(self, size, radius, hover, active)
    local bg_color = self.ontop_button_bg_color
    local fg_color
    if hover then
        fg_color = self.ontop_button_fg_color
    else
        fg_color = self.ontop_button_bg_color
    end
    local img, cr = util.titlebar_button(size, radius, bg_color, fg_color)

    -- draw content
    local active_color
    if active or hover then
        active_color = self.ontop_button_fg_color
    else
        active_color = self.ontop_button_bg_color
    end
    cr:set_source(gears.color(active_color))
    local width = radius
    local height = radius
    local x = (size - width) / 2
    local y = (size - height) / 2
    local shape =
        gears.shape.transform(gears.shape.isosceles_triangle):translate(x, y)
    shape(cr, width, height)
    cr:fill()

    return img
end
module.sticky_button = function(self, size, radius, hover, active)
    local bg_color = self.sticky_button_bg_color
    local fg_color
    if hover then
        fg_color = self.sticky_button_fg_color
    else
        fg_color = self.sticky_button_bg_color
    end
    local img, cr = util.titlebar_button(size, radius, bg_color, fg_color)

    -- draw content
    local active_color
    if active or hover then
        active_color = self.sticky_button_fg_color
    else
        active_color = self.sticky_button_bg_color
    end
    cr:set_source(gears.color(active_color))
    local width = radius
    local height = radius
    local x = (size + width) / 2
    local y = (size + height) / 2
    local shape =
        gears.shape.transform(gears.shape.isosceles_triangle):translate(x, y)
            :rotate(math.pi)
    shape(cr, width, height)
    cr:fill()

    return img
end

-- [ return module ] -----------------------------------------------------------
return module
