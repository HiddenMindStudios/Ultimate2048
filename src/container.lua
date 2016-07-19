Container = {}
Container.__index = Container
Container.__class = "container"
--[[
  Purpose: Creates a new Container instance
  Parameters:
    x, y:
      Top-left corner of the container
    w, h:
      Width and height of the container
  Method Overview:
    Stores values and establishes the container.
--]]

Container.codeList = {
  closeContainer = function(self) print("Pending delete") self.pendingDelete = true end
}

Container.new = function(x, y, w, h)
	local s = {}
	setmetatable(s, Container)
	s.x = x
	s.y = y
	s.w = w
	s.h = h
  s.pendingDelete = false
	s.UI = {}
	return s
end

--[[
  Purpose: Set color for background.
  Parameters:
    self:
      Current instance of container
    r,g,b,a:
      Color sets for color
  Method Overview:
    Stores color components in a table.
--]]

Container.setBackgroundColor = function(self, r, g, b, a)
	self.color = {r,g,b,a}
end

--[[
  Purpose: Set Background to Image
  Parameters:
    self:
      This instance of Container
    imgHead:
      The non-directory image path
  Method Overview:
    Sets background to image (Not currently implemented)
--]]

Container.setBackground = function(self, imgHead)
	self.bkgrnd = love.graphics.newImage("img/" .. imgHead)
end

--[[
  Purpose: add a Text Label to container
  Parameters:
    self:
      This instance of Container
    name:
      Label Name for get functions
    txt: 
      Display Text
    x, y:
      Position of text
    font, size, color:
      Display components.
  Method Overview:
    Attempts to make label name, if no label name, store in UI. Else, return false.
--]]

Container.addLabel = function(self, name, txt, x, y, font, size, color)
	if not self.UI[name] then
		x, y = x + self.x, y + self.y
		self.UI[name] = label.new(txt, x, y, font, size, color)
		return true
	else
		return false
	end
end

--[[
  Purpose: Draw callback for Container
  Parameters:
    self:
      This instance of container
  Method Overview:
    Perform the color swap and rectangle draw for color, then draw subcomponents.
--]]

Container.addButton = function(self, name, imgHead, x, y, w, h, pctX, pctY, code)
  if not self.UI[name] and self.codeList[code] then
    x, y = x + self.x, y + self.y
    self.UI[name] = button.new(imgHead, x, y, w, h, pctX, pctY, self.codeList[code], nil, nil)
    return true
  end
end

Container.draw = function(self)
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	for _, UICOMP in pairs(self.UI) do
		UICOMP:draw()
	end
	love.graphics.setColor(r,g,b,a)
end

--[[
  Purpose: Perform update on all subcomponents
  Parameters:
    self:
      This instance of Container
    cX, cY:
      mouse position
  Method Overview:
--]]

Container.onClick = function(self, x, y, btn)
  for name, UICOMP in pairs(self.UI) do
    if UICOMP.onClick and x >= UICOMP.x and x < UICOMP.x + UICOMP.w and y >= UICOMP.y and y <= UICOMP.y + UICOMP.h then
      UICOMP:onClick(x, y, btn)
      if name == "close" then
        self.codeList.closeContainer(self)
      end
    end
  end
end

Container.update = function(self, cX, cY)
	if self.pendingDelete then
    print("Deleting!")
    return false
  end
  for _, UICOMP in pairs(self.UI) do
		if UICOMP.type == "button" then
			UICOMP:update(cX, cY)
		end
	end
  return true
end