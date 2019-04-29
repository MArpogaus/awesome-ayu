local gears = require("gears")
local wibox = require("wibox")

local lain  = require("lain")
local markup = lain.util.markup

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local module = {}

module.fa_ico = function (col, ico)
    local fa_font =  "FontAwesome " .. dpi(8)
    return wibox.widget{
        markup = markup.fontfg(fa_font, col, ico),
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center',
        forced_width = dpi(20)
    }
end

-- stolen from: https://github.com/elenapan/dotfiles/blob/master/config/awesome/noodle/start_screen.lua
-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
module.create_boxed_widget = function (widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.shape = function(c, h, w) gears.shape.rounded_rect(c, h, w, 30) end
    box_container.forced_height = height
    box_container.forced_width = width
    
    local boxed_widget = wibox.widget {
        -- add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    {
                        -- The actual widget goes here
                        widget_to_be_boxed,
                        height = height,
                        width = width,
                        strategy = "min",
                        expand = "none",
                        layout = wibox.layout.constraint,
                    },
                    nil,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                nil,
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            widget = box_container
        },
        margins = dpi(24),
        color = "#FF000000",
        widget = wibox.container.margin,
    }
    
    return boxed_widget
end

module.create_wibox_widget = function (color, icon, widget)
    if type(icon) == "table" then
        icon_widget = icon
    else
        icon_widget = module.fa_ico(color, icon)
    end
    local wibox_widget = wibox.widget {
        {
            -- add margins
            icon_widget,
            left = dpi(10),
            right = dpi(5),
            color = "#FF000000",
            widget = wibox.container.margin
        },
        widget,
        layout = wibox.layout.fixed.horizontal,
        expand = "none"
    }
    return wibox_widget
end

return module
