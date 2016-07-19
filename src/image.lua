Image = {}
Image.__index = Image

Image.new = function(fullImg, x, y, w, h)
	local s = {}
	setmetatable(s, Image)
	s.img = love.graphics.newImage(fullImg)
	s.x = x
	s.y = y
	s.w = w
	s.h = h
	return s
end

Image.draw = function(self)
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor({255,255,255,255})
	love.graphics.draw(self.img, self.x, self.y, 0, self.w, self.h)
	love.graphics.setColor(r,g,b,a)
end

Image.update = function(self)
end
