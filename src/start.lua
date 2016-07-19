local Start = {}
Start.__index = Start

Start.init = function(self, w, h)
	local ttlX = 0
	local ttlY = 0
	local ttlW = w/ imgSize.splash.w
	local ttlH = h/ imgSize.splash.h
	
	Gamestate.UI[1] = Image.new("Assets/main_Title.png", ttlX, ttlY, ttlW, ttlH)
	
	local btnW, btnH = w*.3, h*.16875
	local btnPctX, btnPctY = btnW / imgSize.buttonSize.w, btnH / imgSize.buttonSize.h
	local btnSpace = 1.25*btnH
	
	local playX, playY = (w - btnW)/2, (h - btnH)/2
	local playFxn = function(self) self:set("menu") end
	
	Gamestate.UI[2] = button.new("main_Play", playX, playY, btnW, btnH, btnPctX, btnPctY, playFxn, nil, nil)
end

Start.draw = function(self)
end

Start.update = function(self)
end

Start.keypressed = function(self, key)
	if key == "escape" then
		love.event.quit()
	end
end

return Start