button = {}
button.__index  = button
button.__class = "button"


--button.new (Constructor)
--[[
  Purpose: Creates a new instance of button of width W, Height h, and top-left pos X, Y, 
    with image imgName scaled to pctX, pctY, with functions Left, Right, and Middle fxnL, 
    fxnR, fxnM respectively.
  Parameters:
    imgNew:
      A raw image link without the Asset prependege.
    x, y:
      Position values for top-left corner.
    w, h:
      Size value calculated for sizing the image.
    pctX, pctY:
      The percent scaling value for the image based on w,h for image base size.
    fxnL, fxnR, fxnM:
      The functions called upon button click while mouse is over button.
  Method Overview:
    Assigns all values to a new table instance and creates the grahics objects.

--]]
function button.new(imgName, x, y, w, h, pctX, pctY, fxnL, fnxR, fxnM)
	local s = {}
	setmetatable(s, button)
	local imgHead = "Assets/" .. imgName
	s.img = love.graphics.newImage(imgHead .. ".png")
	s.img_hover = love.graphics.newImage(imgHead .. "_hover.png")
	s.state = "none"
	s.w = w
	s.h = h
	s.x = x
	s.y = y
	s.pctX = pctX
	s.pctY = pctY
	s.fxn1 = fxnL
	s.fxn3 = fxnM
	s.fxn2 = fxnR
	return s
end

--[[
  Purpose: Returns the position components of the button.
  Parameters:
    None
  Method Overview:
    Returns x and y (data accessor for button)
--]]

function button.getPos(self)
	return self.x, self.y
end

--[[
  Purpose: Returns the size components of the button.
  Parameters:
    None
  Method Overview:
    Returns w and h (data accessor for button)
--]]

function button.getSize(self)
	return self.w, self.h
end

--[[
  Purpose: Main Drawing function called externally
  Parameters:
    self
  Method Overview:
    Disassembles the current color and saves it. Sets current draw color to max white,
    checks draw state, and if not none, sets the state to current (hover) and draws the
    image using love.graphics.draw, then resets the color to its original state.
--]]

function button.draw(self)
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor({255,255,255,255})
	local img = "img"
	if self.state ~= "none" then
		img = img .. "_" .. self.state
	end
	love.graphics.draw(self[img], self.x, self.y, 0, self.pctX, self.pctY)
	love.graphics.setColor(r,g,b,a)
end

--[[
  Purpose: Update function for detecting button clicks and hover.
  Parameters:
    self:
      Current instance of button
    dt:
      The delta time (not currently used)
  Method Overview:
    Collects the mouse position and compares it to the buttons size and position.
    If the mouse is in the button's space, change the draw state to hover. If not,
    sets state to none.
--]]

function button.update(self, dt)
	local cursorX, cursorY = love.mouse.getPosition()
	local w, h = self:getSize()
	local x, y = self:getPos()
	if cursorX >= x and cursorX <= x + w and
	cursorY >= y and cursorY <= y + h then
		self.state = "hover"
	elseif self.state ~= "none" then
		self.state = "none"
	end
end

--[[
  Purpose: Performs functions based on click
  Parameters:
    self:
      Current instance of button
    x, y:
      Mouse coords (only used for spaceholding)
    btn:
      Which mouse button was pressed.
  Method Overview:
    Selects method based on button press and calls it, passing external gamestate.
--]]

function button.onClick(self, x, y, btn)
	local fxn = "fxn" .. btn
	if self[fxn] then
		self[fxn](Gamestate)
	end
end

	