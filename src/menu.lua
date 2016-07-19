local Menu = {}
Menu.__index = Menu

Menu.init = function(self, w, h)
	local ttlX = 0
	local ttlY = 0
	local ttlW = w/ imgSize.splash.w
	local ttlH = h/ imgSize.splash.h
	
	Gamestate.UI[1] = Image.new("Assets/main_Title.png", ttlX, ttlY, ttlW, ttlH)
  
  local btnW, btnH = w*.30, h*.16875
  local btnPctX, btnPctY = btnW / imgSize.buttonSize.w, btnH/imgSize.buttonSize.h
  local btnSpace = 1*btnH
  local btnX = (w-btnW)/2
  local btnBaseY = (h-btnH)/2 - h*.1
  
  local newY = btnBaseY
  local newFxn = function(self)self:set("game")end
  
  Gamestate.UI[2] = button.new("menu_newGame", btnX, newY, btnW, btnH, btnPctX, btnPctY, newFxn, nil, nil)
  
  local contY = btnBaseY + btnSpace
  local contFxn = function(self)self:set("menu")end
  
  Gamestate.UI[3] = button.new("menu_continue", btnX, contY, btnW, btnH, btnPctX, btnPctY, contFxn, nil, nil)
  
  local optY = contY + btnSpace
  local optFxn = function(self)self:set("options")end
  
  Gamestate.UI[4] = button.new("menu_options", btnX, optY, btnW, btnH, btnPctX, btnPctY, optFxn, nil, nil)
  
  local exY = optY + btnSpace
  local exFxn = function(self)love.event.quit()end
  
  Gamestate.UI[5] = button.new("menu_exit", btnX, exY, btnW, btnH, btnPctX, btnPctY, exFxn, nil, nil)
end

Menu.draw = function(self)
end

Menu.update = function(self)
end

Menu.keypressed = function(self, key)
end
return Menu
