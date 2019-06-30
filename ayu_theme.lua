local gears = require("gears")
local cairo = require("lgi").cairo

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

local ayu_colors = require("themes.ayu.ayu_colors")

local color_scheme = ayu_colors.light

-- Helper functions for modifying hex colors:
--
local hex_color_match = "[a-fA-F0-9][a-fA-F0-9]"
local function darker(color_value, darker_n)
    local result = "#"
    local channel_counter = 1
    for s in color_value:gmatch(hex_color_match) do
        local bg_numeric_value = tonumber("0x"..s)
        if channel_counter <= 3 then
            bg_numeric_value = bg_numeric_value - darker_n
        end
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%02x", bg_numeric_value)
        channel_counter = channel_counter + 1
    end
    return result
end
local function is_dark(color_value)
    local bg_numeric_value = 0;
    local channel_counter = 1
    for s in color_value:gmatch(hex_color_match) do
        bg_numeric_value = bg_numeric_value + tonumber("0x"..s);
        if channel_counter == 3 then
            break
        end
        channel_counter = channel_counter + 1
    end
    local is_dark_bg = (bg_numeric_value < 383)
    return is_dark_bg
end
local function reduce_contrast(color, ratio)
    ratio = ratio or 50
    return darker(color, is_dark(color) and - ratio or ratio)
end

-- create titlebar_button
local titlebar_button = function(size, radius, bg_color, fg_color)
    -- Create a surface
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
    
    -- Create a context
    local cr = cairo.Context(img)
    
    -- paint transparent bg
    cr:set_source(gears.color("#00000000"))
    cr:paint()
    
    -- draw boarder
    cr:set_source(gears.color(fg_color or "#00000000"))
    cr:move_to(size / 2 + radius, size / 2)
    cr:arc(size / 2, size / 2, radius + 1, 0, 2 * math.pi)
    cr:close_path()
    cr:fill()
    
    -- draw circle
    cr:set_source(gears.color(bg_color))
    cr:move_to(size / 2 + radius, size / 2)
    cr:arc(size / 2, size / 2, radius, 0, 2 * math.pi)
    cr:close_path()
    cr:fill()
    
    return img, cr
end

local theme = {
    set_color_scheme = function(self, cs)
        -- configure theme parameters
        self.confdir = config_path .. "/themes/ayu"
        self.font_name = "Monospace "
        self.font_size = dpi(8)
        self.font = self.font_name .. self.font_size
        self.tasklist_plain_task_name = true
        self.tasklist_disable_icon = true
        self.useless_gap = 0
        self.ico_width = dpi(20)
        self.button_size = dpi(32)
        self.button_radius = dpi(10)
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
        self.border_focus = cs.fg
        self.border_marked = cs.colors[4]
        self.top_bar_height = dpi(20)
        self.bottom_bar_height = dpi(20)
        self.menu_border_width = 0
        self.menu_submenu_icon = themes_path.."default/submenu.png"
        self.menu_height = dpi(15)
        self.menu_width = dpi(150)
        self.menu_fg_normal = cs.fg
        self.menu_fg_focus = cs.colors[4]
        self.menu_bg_normal = cs.bg
        self.menu_bg_focus = cs.bg
        
        -- set colors for buttons and widgets
        self.close_button_fg_color = cs.colors[2] --"#F07171"
        self.maximized_button_fg_color = cs.colors[11] --"#86B300"
        self.minimize_button_fg_color = cs.colors[4] --"#FF9940"
        self.ontop_button_fg_color = cs.colors[13] --"#399EE6"
        self.sticky_button_fg_color = cs.colors[8] --"#ABB0B6"
        
        if cs == ayu_colors.light then
            self.close_button_bg_color = reduce_contrast(self.close_button_fg_color, -70)
            self.maximized_button_bg_color = reduce_contrast(self.maximized_button_fg_color, 70)
            self.minimize_button_bg_color = reduce_contrast(self.minimize_button_fg_color, -70)
            self.ontop_button_bg_color = reduce_contrast(self.ontop_button_fg_color, -70)
            self.sticky_button_bg_color = reduce_contrast(self.sticky_button_fg_color, -50)
        else
            self.close_button_bg_color = reduce_contrast(self.close_button_fg_color, 70)
            self.maximized_button_bg_color = reduce_contrast(self.maximized_button_fg_color, 70)
            self.minimize_button_bg_color = reduce_contrast(self.minimize_button_fg_color, 70)
            self.ontop_button_bg_color = reduce_contrast(self.ontop_button_fg_color, 70)
            self.sticky_button_bg_color = reduce_contrast(self.sticky_button_fg_color, 70)
        end
        
        self.widget_colors = {
            netdown = cs.colors[2],
            netup = cs.colors[3],
            volume = cs.colors[4],
            memory = cs.colors[5],
            cpu = cs.colors[13],
            fs = cs.colors[7],
            weather = cs.colors[10],
            temp = cs.colors[11],
            bat = cs.colors[12],
            cal = cs.colors[16],
            clock = cs.colors[4],
            desktop_clock = cs.colors[8 + 5],
            desktop_day = cs.colors[4],
            desktop_date = cs.colors[2],
            desktop_month = cs.colors[3],
        }

        if cs == ayu_colors.light then
            self.widget_colors.desktop_cpu = {
                fg = cs.colors[8 + 2],
                bg = reduce_contrast(cs.colors[2], -50),
            }
            self.widget_colors.desktop_mem = {
                fg = cs.colors[8 + 3],
                bg = reduce_contrast(cs.colors[3], -50),
            }
            self.widget_colors.desktop_fs = {
                fg = cs.colors[8 + 4],
                bg = reduce_contrast(cs.colors[4], -50),
            }
            self.widget_colors.desktop_bat = {
                fg = cs.colors[8 + 5],
                bg = reduce_contrast(cs.colors[5], -50),
            }
        else
            self.widget_colors.desktop_cpu = {
                fg = cs.colors[8 + 2],
                bg = reduce_contrast(cs.colors[2], 70),
            }
            self.widget_colors.desktop_mem = {
                fg = cs.colors[8 + 3],
                bg = reduce_contrast(cs.colors[3], 70),
            }
            self.widget_colors.desktop_fs = {
                fg = cs.colors[8 + 4],
                bg = reduce_contrast(cs.colors[4], 70),
            }
            self.widget_colors.desktop_bat = {
                fg = cs.colors[8 + 5],
                bg = reduce_contrast(cs.colors[5], 70),
            }
        end
        
        -- generate buttons
        self.titlebar_close_button_normal = self:close_button(self.button_size, self.button_radius, false)
        self.titlebar_close_button_focus = self:close_button(self.button_size, self.button_radius, false)
        self.titlebar_close_button_normal_hover = self:close_button(self.button_size, self.button_radius, true)
        self.titlebar_close_button_focus_hover = self:close_button(self.button_size, self.button_radius, true)
        
        self.titlebar_minimize_button_normal = self:minimize_button(self.button_size, self.button_radius, false)
        self.titlebar_minimize_button_focus = self:minimize_button(self.button_size, self.button_radius, false)
        self.titlebar_minimize_button_normal_hover = self:minimize_button(self.button_size, self.button_radius, true)
        self.titlebar_minimize_button_focus_hover = self:minimize_button(self.button_size, self.button_radius, true)
        
        self.titlebar_maximized_button_normal_active = self:maximized_button(self.button_size, self.button_radius, false, true)
        self.titlebar_maximized_button_focus_active = self:maximized_button(self.button_size, self.button_radius, false, true)
        self.titlebar_maximized_button_normal_inactive = self:maximized_button(self.button_size, self.button_radius, false)
        self.titlebar_maximized_button_focus_inactive = self:maximized_button(self.button_size, self.button_radius, false)
        self.titlebar_maximized_button_normal_active_hover = self:maximized_button(self.button_size, self.button_radius, true)
        self.titlebar_maximized_button_focus_active_hover = self:maximized_button(self.button_size, self.button_radius, true)
        self.titlebar_maximized_button_normal_inactive_hover = self:maximized_button(self.button_size, self.button_radius, true)
        self.titlebar_maximized_button_focus_inactive_hover = self:maximized_button(self.button_size, self.button_radius, true)
        
        self.titlebar_ontop_button_normal_active = self:ontop_button(self.button_size, self.button_radius, false, true)
        self.titlebar_ontop_button_focus_active = self:ontop_button(self.button_size, self.button_radius, false, true)
        self.titlebar_ontop_button_normal_inactive = self:ontop_button(self.button_size, self.button_radius, false)
        self.titlebar_ontop_button_focus_inactive = self:ontop_button(self.button_size, self.button_radius, false)
        self.titlebar_ontop_button_normal_active_hover = self:ontop_button(self.button_size, self.button_radius, true)
        self.titlebar_ontop_button_focus_active_hover = self:ontop_button(self.button_size, self.button_radius, true)
        self.titlebar_ontop_button_normal_inactive_hover = self:ontop_button(self.button_size, self.button_radius, true)
        self.titlebar_ontop_button_focus_inactive_hover = self:ontop_button(self.button_size, self.button_radius, true)
        
        self.titlebar_sticky_button_normal_active = self:sticky_button(self.button_size, self.button_radius, false, true)
        self.titlebar_sticky_button_focus_active = self:sticky_button(self.button_size, self.button_radius, false, true)
        self.titlebar_sticky_button_normal_inactive = self:sticky_button(self.button_size, self.button_radius, false)
        self.titlebar_sticky_button_focus_inactive = self:sticky_button(self.button_size, self.button_radius, false)
        self.titlebar_sticky_button_normal_active_hover = self:sticky_button(self.button_size, self.button_radius, true)
        self.titlebar_sticky_button_focus_active_hover = self:sticky_button(self.button_size, self.button_radius, true)
        self.titlebar_sticky_button_normal_inactive_hover = self:sticky_button(self.button_size, self.button_radius, true)
        self.titlebar_sticky_button_focus_inactive_hover = self:sticky_button(self.button_size, self.button_radius, true)
        
        -- Generate taglist squares:
        local taglist_square_size = dpi(4)
        self.taglist_squares_sel = theme_assets.taglist_squares_sel(
            taglist_square_size, self.fg_focus
        )
        self.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
            taglist_square_size, self.fg_normal
        )
        
        -- Define the image to load
        if cs == ayu_colors.light then
            self.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_focus_inactive.png"
            self.titlebar_floating_button_focus_inactive = themes_path.."default/titlebar/floating_focus_inactive.png"
            self.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_focus_active.png"
            self.titlebar_floating_button_focus_active = themes_path.."default/titlebar/floating_focus_active.png"
        else
            self.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
            self.titlebar_floating_button_focus_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
            self.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
            self.titlebar_floating_button_focus_active = themes_path.."default/titlebar/floating_normal_active.png"
        end
        
        -- load layout icons
        if cs == ayu_colors.light then
            self.layout_fairh = themes_path.."default/layouts/fairh.png"
            self.layout_fairv = themes_path.."default/layouts/fairv.png"
            self.layout_floating = themes_path.."default/layouts/floating.png"
            self.layout_magnifier = themes_path.."default/layouts/magnifier.png"
            self.layout_max = themes_path.."default/layouts/max.png"
            self.layout_fullscreen = themes_path.."default/layouts/fullscreen.png"
            self.layout_tilebottom = themes_path.."default/layouts/tilebottom.png"
            self.layout_tileleft = themes_path.."default/layouts/tileleft.png"
            self.layout_tile = themes_path.."default/layouts/tile.png"
            self.layout_tiletop = themes_path.."default/layouts/tiletop.png"
            self.layout_spiral = themes_path.."default/layouts/spiral.png"
            self.layout_dwindle = themes_path.."default/layouts/dwindle.png"
            self.layout_cornernw = themes_path.."default/layouts/cornernw.png"
            self.layout_cornerne = themes_path.."default/layouts/cornerne.png"
            self.layout_cornersw = themes_path.."default/layouts/cornersw.png"
            self.layout_cornerse = themes_path.."default/layouts/cornerse.png"
        else
            self.layout_fairh = themes_path.."default/layouts/fairhw.png"
            self.layout_fairv = themes_path.."default/layouts/fairvw.png"
            self.layout_floating = themes_path.."default/layouts/floatingw.png"
            self.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
            self.layout_max = themes_path.."default/layouts/maxw.png"
            self.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
            self.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
            self.layout_tileleft = themes_path.."default/layouts/tileleftw.png"
            self.layout_tile = themes_path.."default/layouts/tilew.png"
            self.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
            self.layout_spiral = themes_path.."default/layouts/spiralw.png"
            self.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
            self.layout_cornernw = themes_path.."default/layouts/cornernww.png"
            self.layout_cornerne = themes_path.."default/layouts/cornernew.png"
            self.layout_cornersw = themes_path.."default/layouts/cornersww.png"
            self.layout_cornerse = themes_path.."default/layouts/cornersew.png"
        end
        
        -- Generate Awesome icon:
        self.awesome_icon = theme_assets.awesome_icon(
            self.menu_height, self.bg_normal, self.fg_normal
        )
        
        -- wallpaper
        self.wallpaper = function(s) return gears.surface.load_from_shape(s.workarea.width, s.workarea.height, gears.shape.rectangle, cs.bg) end
    end,
    close_button = function(self, size, radius, hover, active)
        bg_color = self.close_button_bg_color
        if hover then
            fg_color = self.close_button_fg_color
        else
            fg_color = self.close_button_bg_color
        end
        img, cr = titlebar_button(size, radius, bg_color, fg_color)
        
        -- draw content
        if active or hover then
            cr:set_source(gears.color(self.close_button_fg_color))
            local width = 1.5 * radius
            local height = 1.5 * radius
            local thickness = width / 4
            local x = size / 2
            local y = (size - height - width / 3) / 2
            local shape = gears.shape.transform(gears.shape.cross)
            : translate(x, y)
            : rotate(math.pi / 4)
            shape(cr, width, height, thickness)
            cr:fill()
        end
        
        return img
    end,
    maximized_button = function(self, size, radius, hover, active)
        bg_color = self.maximized_button_bg_color
        if hover then
            fg_color = self.maximized_button_fg_color
        else
            fg_color = self.maximized_button_bg_color
        end
        img, cr = titlebar_button(size, radius, bg_color, fg_color)
        
        -- draw content
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
        local shape = gears.shape.transform(gears.shape.cross)
        : translate(x, y)
        shape(cr, width, height, thickness)
        cr:fill()
        
        return img
    end,
    minimize_button = function(self, size, radius, hover, active)
        bg_color = self.minimize_button_bg_color
        if hover then
            fg_color = self.minimize_button_fg_color
        else
            fg_color = self.minimize_button_bg_color
        end
        img, cr = titlebar_button(size, radius, bg_color, fg_color)
        
        -- draw content
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
        local shape = gears.shape.transform(gears.shape.rectangle)
        : translate(x, y)
        shape(cr, width, height)
        cr:fill()
        
        return img
    end,
    ontop_button = function(self, size, radius, hover, active)
        bg_color = self.ontop_button_bg_color
        if hover then
            fg_color = self.ontop_button_fg_color
        else
            fg_color = self.ontop_button_bg_color
        end
        img, cr = titlebar_button(size, radius, bg_color, fg_color)
        
        -- draw content
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
        local shape = gears.shape.transform(gears.shape.isosceles_triangle)
        : translate(x, y)
        shape(cr, width, height)
        cr:fill()
        
        return img
    end,
    sticky_button = function(self, size, radius, hover, active)
        bg_color = self.sticky_button_bg_color
        if hover then
            fg_color = self.sticky_button_fg_color
        else
            fg_color = self.sticky_button_bg_color
        end
        img, cr = titlebar_button(size, radius, bg_color, fg_color)
        
        -- draw content
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
        local shape = gears.shape.transform(gears.shape.isosceles_triangle)
        : translate(x, y)
        : rotate(math.pi)
        shape(cr, width, height)
        cr:fill()
        
        return img
    end
}

theme:set_color_scheme(color_scheme)

return theme
