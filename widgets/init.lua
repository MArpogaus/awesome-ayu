--------------------------------------------------------------------------------
-- @File:   init.lua
-- @Author: Marcel Arpogaus
-- @Date:   2020-09-26 20:19:50
--
-- @Last Modified by: Marcel Arpogaus
-- @Last Modified at: 2020-10-19 16:12:46
-- [ description ] -------------------------------------------------------------
-- metatable to create register and unregister vicious widgets
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
local wibox = require('wibox')

local vicious = require('vicious')

local util = require('themes.ayu.util')

-- [ local objects ] -----------------------------------------------------------
local name = ...
local module = {}

local registered_widgets

-- [ local functions ] ---------------------------------------------------------
local function create_widget(widget_def, widget_container, timeout)
    assert(
        registered_widgets,
        'module not initialized for screen. call ' .. name ..
            '.init(screen) fist!'
    )

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
        widget_generator['create_' .. k .. '_widget'] =
            function(wargs)
                wargs = wargs or {}
                local widget_def = wd(wargs)
                local timeout = wargs.timeout or widget_def.default_timeout
                if k == 'wibar' then
                    return create_widget(
                               widget_def, util.create_wibar_widget, timeout
                           )
                elseif k == 'arc' then
                    return create_widget(
                               widget_def, util.create_arc_widget, timeout
                           )
                else
                    return create_widget(
                               widget_def, widget_def.widget_container, timeout
                           )
                end
            end
    end

    return widget_generator
end

module.unregister_widgets = function()
    for i, w in pairs(registered_widgets) do
        vicious.unregister(w)
    end
    registered_widgets = {}
end

module.update_widgets = function() vicious.force(registered_widgets) end

module.init = function(s)
    if s.registered_widgets then
        registered_widgets = s.registered_widgets
    else
        s.registered_widgets = {}
        registered_widgets = s.registered_widgets
    end
end

-- [ return module ] -----------------------------------------------------------
return module
