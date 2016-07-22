label = {}
label.__index = label

label.new = function(txt, x, y, size, font, cTable)
	local s = {}
	setmetatable(s, label)
	if font == nil then
		font = "std"
	end
	s.text = txt
	s.x = x
	s.y = y
	s.size = size
	s.font = font
	s.color = cTable
	return s
end

label.getText = function(self)
  return self.text
end

label.setText = function(self, txt)
	self.text = txt
end

label.setPos = function(self, x, y)
	self.x = x
	self.y = y
end

label.update = function(self)
end

label.draw = function(self)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color)
	Font.setFont(self.font, self.size)
	love.graphics.print(self.text, self.x, self.y)
	Font.resetFont()
	love.graphics.setColor(r,g,b,a)
end