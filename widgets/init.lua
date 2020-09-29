--------------------------------------------------------------------------------
-- @File:   init.lua
-- @Author: Marcel Arpogaus
-- @Date:   2020-09-26 20:19:50
-- [ description ] -------------------------------------------------------------
-- ...
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-29 13:03:38
-- @Changes: 
--      - newly written
--      - ...
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- @File:   battery.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-06-16 10:35:55
-- [ description ] -------------------------------------------------------------
-- battery widgets
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-09-26 20:14:37
-- @Changes: 
--      - ported to vicious
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2020-06-01 11:14:16
-- @Changes: 
--      - fixes for new lain version
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-11-18 10:40:43
-- @Changes: 
--      - removed apply_dpi to make use of new DPI handling in v4.3
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-15 08:31:41
-- @Changes: 
--      - remove color as function argument
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-07-02 09:43:15
-- @Changes: 
--      - newly written
--------------------------------------------------------------------------------
-- [ modules imports ] ---------------------------------------------------------
local setmetatable = setmetatable

local wibox = require('wibox')

local vicious = require('vicious')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local module = {}

local registered_widgets = {}

-- [ local functions ] ---------------------------------------------------------
local function gen_widget(widget_def, widget_container, timeout)
    local widget_container_args = widget_def.container_args or {}
    for key, w in pairs(widget_def.widgets) do
        -- define widget
        local widget
        if w.widget then
            widget = w.widget
        else
            widget = wibox.widget.textbox()
        end
        widget_container_args[key] = widget

        -- register widget
        if w.wtype and w.format then
            vicious.register(widget, w.wtype, w.format, timeout, w.warg)
            -- bookkeeping to unregister widget
            table.insert(registered_widgets, widget)
        end
    end

    -- return widget container
    return widget_container(widget_container_args)
end

-- [ module functions ] --------------------------------------------------------
module.new = function(args)
    local widget_generator = {}

    for k, wd in pairs(args) do
        widget_generator['gen_' .. k .. '_widget'] =
            function(wargs)
                wargs = wargs or {}
                local widget_def = wd(wargs)
                local timeout = wargs.timeout or widget_def.default_timeout
                if k == 'wibar' then
                    return gen_widget(
                               widget_def, util.create_wibar_widget_new,
                               timeout
                           )
                elseif k == 'arc' then
                    return gen_widget(
                               widget_def, util.create_arc_widget_new, timeout
                           )
                else
                    return gen_widget(
                               widget_def, widget_def.widget_container, timeout
                           )
                end
            end
    end

    -- define a metatable
    setmetatable(widget_generator, module)

    return widget_generator

end

module.unregister_widgets = function()
    for _, w in pairs(registered_widgets) do vicious.unregister(w) end
    registered_widgets = {}
end

-- [ return module object ] -----------.----------------------------------------
return module
