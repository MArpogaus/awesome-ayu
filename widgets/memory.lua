--------------------------------------------------------------------------------
-- @File:   memory.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- memory widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-27 23:41:14
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

local registered_widgets = {}

local mem_icon = ''

local default_timeout = 7

-- [ module functions ] --------------------------------------------------------
module.gen_wibar_widget = function(timeout)
    -- define widgets
    local mem_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function mem_widget_formatter(_, args)
        return util.fontfg(
                   beautiful.font, beautiful.widget_colors.memory,
                   args[1] .. '%'
               )
    end

    -- register widgets
    vicious.register(
        mem_widget, vicious.widgets.mem, mem_widget_formatter,
        timeout or default_timeout
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, mem_widget)

    -- return wibar widget
    return util.create_wibar_widget(
               beautiful.widget_colors.memory, mem_icon, mem_widget
           )
end

module.create_arc_widget = function(timeout)
    -- define widgets
    local mem_widget = wibox.widget.textbox()

    -- define custom formatting function
    local function mem_widget_formatter(widget, args)
        widget:emit_signal_recursive('widget::value_changed', args[1])
        return util.fontfg(
                   beautiful.font_name .. 8,
                   beautiful.widget_colors.desktop_mem.fg, args[1] .. '%'
               )
    end

    -- register widgets
    vicious.register(
        mem_widget, vicious.widgets.mem, mem_widget_formatter,
        timeout or default_timeout
    )

    -- bookkeeping to unregister widgets
    table.insert(registered_widgets, mem_widget)

    -- return arc widget
    return util.create_arc_widget(
               mem_icon, mem_widget, beautiful.widget_colors.desktop_mem.bg,
               beautiful.widget_colors.desktop_mem.fg, 0, 100
           )
end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ sequential code ] ---------------------------------------------------------
-- enable caching
vicious.cache(vicious.widgets.mem)

-- [ return module object ] -----------.----------------------------------------
return module
