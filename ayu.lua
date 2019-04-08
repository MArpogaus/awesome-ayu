local gears = require("gears")
local cairo = require("lgi").cairo

local module = {
  colors = {
    mirage = {
      accent = "#FFCC66",
      bg = "#1F2430",
      fg = "#CBCCC6",
      ui = "#707A8C",
      tag = "#5CCFE6",
      func = "#FFD580",
      entity = "#73D0FF",
      string = "#BAE67E",
      regexp = "#95E6CB",
      markup = "#F28779",
      keyword = "#FFA759",
      special = "#FFE6B3",
      comment = "#5C6773",
      localant = "#D4BFFF",
      operator = "#F29E74",
      error = "#FF3333",
      added = "#A6CC70",
      modified = "#77A8D9",
      removed = "#F27983"
    },
    light = {
      accent = "#FF9940",
      bg = "#FAFAFA",
      fg = "#6C7680",
      ui = "#959DA6",
      tag = "#55B4D4",
      func = "#F2AE49",
      entity = "#399EE6",
      string = "#86B300",
      regexp = "#4CBF99",
      markup = "#F07171",
      keyword = "#FA8D3E",
      special = "#E6BA7E",
      comment = "#ABB0B6",
      localant = "#A37ACC",
      operator = "#ED9366",
      error = "#F51818",
      added = "#99BF4D",
      modified = "#709ECC",
      removed = "#F27983"
    },
    dark = {
      accent = "#E6B450",
      bg = "#0A0E14",
      fg = "#B3B1AD",
      ui = "#3D424D",
      tag = "#39BAE6",
      func = "#FFB454",
      entity = "#59C2FF",
      string = "#C2D94C",
      regexp = "#95E6CB",
      markup = "#F07178",
      keyword = "#FF8F40",
      special = "#E6B673",
      comment = "#626A73",
      localant = "#FFEE99",
      operator = "#F29668",
      error = "#FF3333",
      added = "#91B362",
      modified = "#6994BF",
      removed = "#D96C75"
    }
  }
}

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
local function mix(color1, color2, ratio)
    ratio = ratio or 0.5
    local result = "#"
    local channels1 = color1:gmatch(hex_color_match)
    local channels2 = color2:gmatch(hex_color_match)
    for _ = 1,3 do
        local bg_numeric_value = math.ceil(
          tonumber("0x"..channels1())*ratio +
          tonumber("0x"..channels2())*(1-ratio)
        )
        if bg_numeric_value < 0 then bg_numeric_value = 0 end
        if bg_numeric_value > 255 then bg_numeric_value = 255 end
        result = result .. string.format("%02x", bg_numeric_value)
    end
    return result
end
local function reduce_contrast(color, ratio)
    ratio = ratio or 50
    return darker(color, is_dark(color) and -ratio or ratio)
end

local function choose_contrast_color(reference, candidate1, candidate2)  -- luacheck: no unused
    if is_dark(reference) then
        if not is_dark(candidate1) then
            return candidate1
        else
            return candidate2
        end
    else
        if is_dark(candidate1) then
            return candidate1
        else
            return candidate2
        end
    end
end

local titlebar_button = function(size, radius, bg_color, fg_color)
    -- Create a surface
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)

    -- Create a context
    local cr  = cairo.Context(img)

    -- paint transparent bg
    cr:set_source(gears.color("#00000000"))
    cr:paint()

    -- draw boarder
    cr:set_source(gears.color(fg_color or "#00000000"))
    cr:move_to(size/2+radius, size/2)
    cr:arc(size / 2, size / 2, radius + 1, 0, 2*math.pi)
    cr:close_path()
    cr:fill()

    -- draw circle
    cr:set_source(gears.color(bg_color))
    cr:move_to(size/2+radius, size/2)
    cr:arc(size / 2, size / 2, radius, 0, 2*math.pi)
    cr:close_path()
    cr:fill()

    return img, cr
end

module.ui = {
  set_color_scheme = function(self, cs)
    self.close_button_fg_color = cs.markup  --"#F07171"
    self.maximized_button_fg_color = cs.string  --"#86B300"
    self.minimize_button_fg_color = cs.accent  --"#FF9940"
    self.ontop_button_fg_color = cs.entity  --"#399EE6"
    self.sticky_button_fg_color = cs.comment  --"#ABB0B6"

    if cs == module.colors.light then
      self.close_button_bg_color = reduce_contrast(self.close_button_fg_color, -70) --"#F0B4B4"
      self.maximized_button_bg_color = reduce_contrast(self.maximized_button_fg_color, 70)  --"#D5E6A1"
      self.minimize_button_bg_color = reduce_contrast(self.minimize_button_fg_color, -70)  --"#FFD6B3"
      self.ontop_button_bg_color = reduce_contrast(self.ontop_button_fg_color, -70)  --"#A1CAE6"
      self.sticky_button_bg_color = reduce_contrast(self.sticky_button_fg_color, -50)  --"#B8C2CC"
    else
      self.close_button_bg_color = reduce_contrast(self.close_button_fg_color, 70)
      self.maximized_button_bg_color = reduce_contrast(self.maximized_button_fg_color, 70)
      self.minimize_button_bg_color = reduce_contrast(self.minimize_button_fg_color, 70)
      self.ontop_button_bg_color = reduce_contrast(self.ontop_button_fg_color, 70)
      self.sticky_button_bg_color = reduce_contrast(self.sticky_button_fg_color, 70)
    end

    self.widget_colors = {
      netdown = cs.entity,   -- #399EE6
      netup   = cs.keyword,  -- #FA8D3E
      volume  = cs.markup,   -- #F07171
      memory  = cs.string,   -- #86B300
      cpu     = cs.modified, -- #709ECC
      weather = cs.func,     -- #F2AE49
      temp    = cs.removed,  -- #F27983
      bat     = cs.added,    -- #99BF4D
      cal     = cs.fg,       -- #6C7680
      clock   = cs.accent    -- #FF9940
    }
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
          : translate(x,y)
          : rotate(math.pi/4)
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
        : translate(x,y)
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
      local y = (size - height) /2
      local shape =  gears.shape.transform(gears.shape.rectangle)
        : translate(x,y)
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
      local y = (size - height) /2
      local shape =  gears.shape.transform(gears.shape.isosceles_triangle)
        : translate(x,y)
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
      local y = (size + height) /2
      local shape =  gears.shape.transform(gears.shape.isosceles_triangle)
        : translate(x,y)
        : rotate(math.pi)
      shape(cr, width, height)
      cr:fill()

      return img
  end
}

module.ui:set_color_scheme(module.colors.light)

return module