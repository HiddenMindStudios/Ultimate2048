Font = {}
Font.__index = Font
Font.__class = "font"

Font.init = function()
  Font.list = {
    ["std"] = {
      [12] = love.graphics.newFont(12)
    }
  }
  Font.lastFont = ""
end

Font.newFont = function(fontName, fontSize)
  --if font name non-exist
  if fontName == "std" then
    if not Font.list[fontName][fontSize] then
      Font.list[fontName][fontSize] = love.graphics.newFont(fontSize)
      return
    end
  end
  if not Font.list[fontName] then
    Font.list[fontName] = {}
  end
  if not Font.list[fontName][fontSize] then
    Font.list[fontName][fontSize] = love.graphics.newFont("../Assets/fonts/" .. fontName .. ".ttf", size)
  end
end

Font.setFont = function(fontName, fontSize)
  if not Font.list[fontName] then
    return
  end
  if not Font.list[fontName][fontSize] then
    Font.newFont(fontName, fontSize)
  end
  Font.lastFont = love.graphics.getFont()
  Font.cFont = {fontName, fontSize}
  love.graphics.setFont(Font.list[fontName][fontSize])
end

Font.isFont = function(fontName, fontSize)
  if not Font.list[fontName] then
    return false
  elseif not Font.list[fontName][fontSize] then
    return false
  else
    return true
  end
end

Font.getWidthOfText = function(text)
  return Font.list[Font.cFont[1]][Font.cFont[2]]:getWidth(text)
end

Font.getHeightOfText = function(text)
  return Font.list[Font.cFont[1]][Font.cFont[2]]:getHeight(text)
end

Font.resetFont = function()
  if Font.lastFont == "" then
    return
  end
  love.graphics.setFont(Font.lastFont)
  Font.lastFont = ""
end

Font.init()