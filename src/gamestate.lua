Gamestate = {}
States = {}
Gamestate.get = function(self)
	return self._state
end

Gamestate.set = function(self, whatState)
	local w, h = love.graphics.getDimensions()
  print("Loading for " .. w .. "x" .. h)
	self._state = whatState
	self:clearUI()
	self:load_generic()
	States[whatState]:init(w, h)
end

Gamestate.draw = function(self, w, h)
	States[self:get()]:draw()
	for _, UICOMP in ipairs(self.UI) do
		UICOMP:draw()
	end
	love.graphics.print(self:get(),0,0)
end

Gamestate.clearUI = function(self)
	self.UI = {}
end

Gamestate.cycle = function(self)
  print("cycled")
  local w, h = love.window.getMode()
  local fxn = "load_" .. self:get()
	self:clearUI()
	self:load_generic()
	States[self:get()]:init(w, h)
end

Gamestate.load_generic = function(self)
	local bindDir = "data/keybindings/" .. self:get() .. "/"
	Keybindings.init(require(bindDir.."initBindings"), require(bindDir.."internalFXN"), require(bindDir.."keyNames"))
end

--ALL updates go through this function
Gamestate.update = function(self, dt)
 for id, UICOMP in pairs(self.UI) do
		if not UICOMP.update then
			assert(false, UICOMP.__class)
		end  
    pDel = UICOMP:update(dt)
    if UICOMP.__class == "container" and not pDel then
      Gamestate.UI[id] = nil
      print("Deleted container id " .. id)
    end
	end
  States[self:get()]:update(dt)
end

Gamestate.mousereleased = function(self, x, y, btn)
	local s = self:get()
  for _, edit in pairs(self.UI) do
    if edit.__class == "edit" then
      edit.focus = false
    end
  end
	for _, UICOMP in pairs(self.UI) do
		--if fxn & x In UICOMP & y In UICOMP
		if UICOMP.onClick and x >= UICOMP.x and x <= UICOMP.x + UICOMP.w and y >= UICOMP.y and y <= UICOMP.y + UICOMP.h then
			UICOMP:onClick(x, y, btn)
		end
	end
end

Gamestate.keypressed = function(self, key)
	local s = self:get()
	Keybindings.onKeyPress(key)
  for _, UICOMP in pairs(self.UI) do
    if UICOMP.keypressed then
      UICOMP:keypressed(key)
    end
  end
end

Gamestate.keyreleased = function(self, key)
  local s = self:get()
  Keybindings.onKeyRelease(key)
  for _, UICOMP in pairs(self.UI) do
    if UICOMP.keyreleased then
      UICOMP:keyreleased(key)
    end
  end
end