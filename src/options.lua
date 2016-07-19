local Options = {
  state = "main"
}
Options.__index = Options

Options.init = function(self, w, h)
  local btnW, btnH = w*.3, h*.16875
  local btnPctX, btnPctY = btnW/imgSize.buttonSize.w, btnH/imgSize.buttonSize.h
  local btnSpace = 1*btnH
  local btnX = (w-btnW)/2
  local btnBaseY = h*.247
  
  if self.state == "work" then
    Gamestate.UI[1] = label.new("Currently Under work!", 20, 20, 72, "std", {255,255,255,255})
  
  elseif self.state == "main" then
  
    local gpY = btnBaseY
    local gpFxn = function(self)Options:optionSetState("gameplay")end
  
    Gamestate.UI[1] = button.new("options_gameplay", btnX, gpY, btnW, btnH, btnPctX, btnPctY, gpFxn, nil, nil)
  elseif self.state == "gameplay" then
    local gSY = btnBaseY
  end
  
end

Options.update = function(self, dt)
end

Options.draw = function(self)
  love.graphics.print(self.state, 0, 12)
end

Options.optionSetState = function(self, state)
  self.state = state
  Gamestate:cycle()
end

return Options