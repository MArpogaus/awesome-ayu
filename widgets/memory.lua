--------------------------------------------------------------------------------
-- @File:   memory.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- memory widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 17:46:40
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:41:10
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:41:56
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:20:02
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local wibox = require('wibox')
local beautiful = require('beautiful')

local vicious = require('vicious')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}
local mem_icon = ''

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function()
    local mem_widget = wibox.widget.textbox()
    vicious.register(mem_widget, vicious.widgets.mem, util.fontfg(
                         beautiful.font, beautiful.widget_colors.memory, '$1%'),
                     1)

    return util.create_wibar_widget(beautiful.widget_colors.memory, mem_icon,
                                    mem_widget)
end

module.create_arc_widget = function()
    local mem_widget = wibox.widget.textbox()
    vicious.register(mem_widget, vicious.widgets.mem, function(widget, args)
        widget:emit_signal_recursive('widget::value_changed', args[1])
        return util.fontfg(beautiful.font_name .. 8,
                           beautiful.widget_colors.desktop_mem.fg,
                           args[1] .. '%')
    end, 1)

    return util.create_arc_widget(mem_icon, mem_widget,
                                  beautiful.widget_colors.desktop_mem.bg,
                                  beautiful.widget_colors.desktop_mem.fg, 0,
                                  100)
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.mem)

-- [ return module object ] -----------.----------------------------------------
return module
