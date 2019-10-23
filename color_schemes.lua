-- colors taken from https://github.com/ayu-theme/ayu-colors
local xresources = require("beautiful.xresources")

local module = {
    light = {
        bg = "#FAFAFA",
        fg = "#6C7680",
        colors = {
            "#FAFAFA", "#F07171", "#99BF4D", "#FF9940", "#55B4D4", "#ED9366", "#709ECC", "#ABB0B6",
            "#959DA6", "#F27983", "#86B300", "#F2AE49", "#399EE6", "#FA8D3E", "#4CBF99", "#6C7680"
        }
    },
    mirage = {
        bg = "#1F2430",
        fg = "#CBCCC6",
        colors = {
            "#1F2430", "#F28779", "#A6CC70", "#FFCC66", "#5CCFE6", "#F29E74", "#77A8D9", "#5C6773",
            "#707A8C", "#F27983", "#BAE67E", "#FFD580", "#73D0FF", "#FFA759", "#95E6CB", "#CBCCC6"
        }
    },
    dark = {
        bg = "#0A0E14",
        fg = "#B3B1AD",
        colors = {
            "#0A0E14", "#F07178", "#91B362", "#E6B450", "#39BAE6", "#F29668", "#6994BF", "#626A73",
            "#3D424D", "#D96C75", "#C2D94C", "#FFB454", "#59C2FF", "#FF8F40", "#95E6CB", "#B3B1AD"
        }
    },
    xrdb = function()
        local xrdb = xresources.get_current_theme()
        return {
            bg = xrdb.background,
            fg = xrdb.foreground,
            colors = {
                xrdb.color0, xrdb.color1, xrdb.color2, xrdb.color3, xrdb.color4,
                xrdb.color5, xrdb.color6, xrdb.color7, xrdb.color8, xrdb.color9,
                xrdb.color10, xrdb.color11, xrdb.color12, xrdb.color13,
                xrdb.color14, xrdb.color15
            }
        }
    end
}

return module
