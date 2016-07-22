local Options = {
  state = "main"
}
Options.__index = Options

Options.fsFST = {
  "none",
  "borderless",
  "fullscreen"
}

Options.getState = function(self)
  return self.state
end

Options.updateSetting = function(self, sCode, param)
  if not _settings[sCode] and sCode ~= "screenSize" and sCode ~= "fs/fst" then
    print("Bad code: " .. sCode)
    return
  end
  if sCode == "gridOutline" then
    if _settings.gridOutline == 0 then
      _settings.gridOutline = 1
    else
      _settings.gridOutline = 0
    end
  elseif sCode == "gridSize" or sCode == "tileCountW" or sCode == "tileCountH" then
    local i = _settings[sCode] + param
    if i >= _settingsMin[sCode] and i <= _settingsMax[sCode] then
      print("Set code " .. sCode .. " to " .. i)
      _settings[sCode] = i
    else
      print("Bad Param " .. i)
    end
  elseif sCode == "screenSize" then
    _data.resLoad()
    local cIndex = param
    print("Got ss param " .. param)
    for k, v in ipairs(ScreenModes) do
      if tostring(v.width) == tostring(_settings.w) and tostring(v.height) == tostring(_settings.h) then
        cIndex = cIndex + k
        print("Added " .. k .. " to cIndex")
      end
    end
    if cIndex <= 0 then
      cIndex = #ScreenModes
    elseif cIndex > #ScreenModes then
      cIndex = 1
    end
    print("cIndex: " .. cIndex)
    _settings.w = ScreenModes[cIndex].width
    _settings.h = ScreenModes[cIndex].height
  elseif sCode == "fs/fst" then
    i = 0
    if _settings.fullscreen == 1 and _settings.fullscreenType == "desktop" then
      i = 2
    elseif _settings.fullscreen == 1 and _settings.fullscreenType == "exclusive" then
      i = 3
    else
      i = 1
    end
    i = i + param
    if i <= 0 then
      i = 3
    elseif i > 3 then
      i = 1
    end
    if i == 1 then
      _settings.fullscreen = 0
    elseif i == 2 then
      _settings.fullscreen = 1
      _settings.fullscreenType = "desktop"
    else
      _settings.fullscreen = 1
      _settings.fullscreenType = "exclusive"
    end
  elseif sCode == "vsync" then
    _settings.vsync = math.abs(_settings.vsync - 1)
  elseif sCode == "monitor" then
    local max = love.window.getDisplayCount()
    local c = _settings.monitor + param
    if c <= 0 then
      c = max
    elseif c > max then
      c = 1
    end
    _settings.monitor = c
  end
  saveSettings()
  self:updateUI()
end

Options.init = function(self, w, h) 
  self.w, self.h = w, h
  local btnW, btnH = w*.3, h*.16875
  local btnPctX, btnPctY = btnW/imgSize.buttonSize.w, btnH/imgSize.buttonSize.h
  local btnSpace = 1*btnH
  local btnX = (w-btnW)/2
  local btnBaseY = h*.247
  
  if self.state == "work" then
    Gamestate.UI[1] = label.new("Currently Under work!", 20, 20, 72, "std", {255,255,255,255})
  
  elseif self.state == "main" then
  
    local gpY = btnBaseY
    local gpFxn = function(self)Options:setState("gameplay")end
    
    local vdY = gpY + 1*btnH
    local vdFxn = function(self)Options:setState("video")end
    
    Gamestate.UI[1] = button.new("options_gameplay", btnX, gpY, btnW, btnH, btnPctX, btnPctY, gpFxn, nil, nil)
    Gamestate.UI[2] = button.new("options_video", btnX, vdY, btnW, btnH, btnPctX, btnPctY, vdFxn, nil, nil)
  
  elseif self.state == "video" then
    local fSize = math.floor(w*.02)
    local modW = w*.02
    local modH = h*.02
    Font.newFont("std", fSize)
    btnPctX, btnPctY = modW/imgSize.square.w, modH/imgSize.square.h
    
    local ssLFxn = function(self)Options:updateSetting("screenSize", -1)end
    local ssRFxn = function(self)Options:updateSetting("screenSize", 1) end
    
    local fsLFxn = function(self)Options:updateSetting("fs/fst", -1)end
    local fsRFxn = function(self)Options:updateSetting("fs/fst", 1) end
    
    local vsFxn = function(self)Options:updateSetting("vsync", nil) end
    
    local mnLFxn = function(self)Options:updateSetting("monitor", -1)end
    local mnRFxn = function(self)Options:updateSetting("monitor", 1) end
    
    Gamestate.UI[1] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[2] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, ssLFxn, nil, nil)
    Gamestate.UI[3] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, ssRFxn, nil, nil)
    
    Gamestate.UI[4] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[5] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, fsLFxn, nil, nil)
    Gamestate.UI[6] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, fsRFxn, nil, nil)
    
    Gamestate.UI[7] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[8] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, vsFxn, nil, nil)
    Gamestate.UI[9] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, vsFxn, nil, nil)
    
    Gamestate.UI[10] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[11] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, mnLFxn, nil, nil)
    Gamestate.UI[12] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, mnRFxn, nil, nil)
  self:updateUI()
  
  elseif self.state == "gameplay" then
    local modW = w*.02
    local modH = h*.02
   local fSize = math.floor(w*.02)
    Font.newFont("std", fSize)
    btnPctX, btnPctY = modW/imgSize.square.w, modH/imgSize.square.h
    
    local golFxn = function(self)Options:updateSetting("gridOutline", nil) end
    
    local gsLFxn = function(self)Options:updateSetting("gridSize", -5) end
    local gsRFxn = function(self)Options:updateSetting("gridSize", 5) end
    
    local tWLFxn = function(self)Options:updateSetting("tileCountW", -1) end
    local tWRFxn = function(self)Options:updateSetting("tileCountW", 1) end
    
    local tHLFxn = function(self)Options:updateSetting("tileCountH", -1) end
    local tHRFxn = function(self)Options:updateSetting("tileCountH", 1) end
    
   --Grid Outline
    Gamestate.UI[1] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[2] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, golFxn, nil, nil)
    Gamestate.UI[3] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, golFxn, nil, nil)
    --Grid Size
    Gamestate.UI[4] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[5] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, gsLFxn, nil, nil)
    Gamestate.UI[6] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, gsRFxn, nil, nil)
    --tileCountW
    Gamestate.UI[7] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[8] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, tWLFxn, nil, nil)
    Gamestate.UI[9] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, tWRFxn, nil, nil)
    --tileCountH
    Gamestate.UI[10] = label.new("", 0, 0, fSize, "std", {255,255,255,255})
    Gamestate.UI[11] = button.new("options_modLeft", 0, 0, modW, modH, btnPctX, btnPctY, tHLFxn, nil, nil)
    Gamestate.UI[12] = button.new("options_modRight", 0, 0, modW, modH, btnPctX, btnPctY, tHRFxn, nil, nil)
    
    self:updateUI()
  end
end

Options.updateUI = function(self)
  local _STARTIME_ = os.clock()
  local w, h = self.w, self.h
  Font.setFont("std", math.floor(w*.02))
  local startY = h*.2
  local s = ""
  if self.state == "gameplay" then
    if _settings.gridOutline == 1 then
      s = "On"
    else
      s = "Off"
    end
    Gamestate.UI[1]:setText("Grid Outline: " .. s)
    Gamestate.UI[4]:setText("Grid Size: " .. _settings.gridSize .. "%")
    Gamestate.UI[7]:setText("Tiles Wide: " .. _settings.tileCountW)
    Gamestate.UI[10]:setText("Tiles High: " .. _settings.tileCountH)
    local golX = (w - (Font.getWidthOfText(Gamestate.UI[1]:getText())))/2
    
    local gsY  = startY + 1.05*Font.getHeightOfText(Gamestate.UI[1]:getText())
    local tWY  = gsY + 1.05*Font.getHeightOfText(Gamestate.UI[4]:getText())
    local tHY  = tWY + 1.05*Font.getHeightOfText(Gamestate.UI[7]:getText())
    
    Gamestate.UI[1]:setPos(golX, startY)
    Gamestate.UI[2]:setPos(golX - 1.1*Gamestate.UI[2].w, startY)
    Gamestate.UI[3]:setPos(golX + Font.getWidthOfText(Gamestate.UI[1]:getText()), startY)
    
    Gamestate.UI[4]:setPos(golX, gsY)
    Gamestate.UI[5]:setPos(golX - 1.1*Gamestate.UI[5].w, gsY)
    Gamestate.UI[6]:setPos(golX + Font.getWidthOfText(Gamestate.UI[4]:getText()), gsY)    
    
    Gamestate.UI[7]:setPos(golX, tWY)
    Gamestate.UI[8]:setPos(golX - 1.1*Gamestate.UI[8].w, tWY)
    Gamestate.UI[9]:setPos(golX + Font.getWidthOfText(Gamestate.UI[7]:getText()), tWY)    
    
    Gamestate.UI[10]:setPos(golX, tHY)
    Gamestate.UI[11]:setPos(golX - 1.1*Gamestate.UI[11].w, tHY)
    Gamestate.UI[12]:setPos(golX + Font.getWidthOfText(Gamestate.UI[10]:getText()), tHY)
  
  elseif self.state == "video" then
    Gamestate.UI[1]:setText("Screen Size: " .. _settings.w .. "x" .. _settings.h)
    local s = ""
    if _settings.fullscreenType == "desktop" then
      s = "Windowed (Borderless)"
    elseif _settings.fullscreenType == "exclusive" then
      s = "Fullscreen"
    end
    if _settings.fullscreen == 0 then
      s = "Windowed"
    end
    Gamestate.UI[4]:setText("Fullscreen Mode: " .. s)
    
    if _settings.vsync == 1 then
      s = "On"
    else
      s = "Off"
    end
    Gamestate.UI[7]:setText("Vsync: " .. s)
    
    Gamestate.UI[10]:setText("Monitor: " .. _settings.monitor)
    
    local bX = (w - (Font.getWidthOfText(Gamestate.UI[1]:getText())))/2
    
    local fsY = startY + 1.05*Font.getHeightOfText(Gamestate.UI[1]:getText())
    local vsY = fsY + 1.05*Font.getHeightOfText(Gamestate.UI[4]:getText())
    local mnY = vsY + 1.05*Font.getHeightOfText(Gamestate.UI[7]:getText())
    
    Gamestate.UI[1]:setPos(bX, startY)
    Gamestate.UI[2]:setPos(bX - 1.1*Gamestate.UI[2].w, startY)
    Gamestate.UI[3]:setPos(bX + Font.getWidthOfText(Gamestate.UI[1]:getText()), startY)
    
    Gamestate.UI[4]:setPos(bX, fsY)
    Gamestate.UI[5]:setPos(bX - 1.1*Gamestate.UI[2].w, fsY)
    Gamestate.UI[6]:setPos(bX + Font.getWidthOfText(Gamestate.UI[4]:getText()), fsY)
        
    Gamestate.UI[7]:setPos(bX, vsY)
    Gamestate.UI[8]:setPos(bX - 1.1*Gamestate.UI[8].w, vsY)
    Gamestate.UI[9]:setPos(bX + Font.getWidthOfText(Gamestate.UI[7]:getText()), vsY)
        
    Gamestate.UI[10]:setPos(bX, mnY)
    Gamestate.UI[11]:setPos(bX - 1.1*Gamestate.UI[11].w, mnY)
    Gamestate.UI[12]:setPos(bX + Font.getWidthOfText(Gamestate.UI[10]:getText()), mnY)
    
  end
  Font.resetFont()
end

Options.update = function(self, dt)
end

Options.draw = function(self)
  love.graphics.print(self.state, 0, 12)
end

Options.setState = function(self, state)
  self.state = state
  Gamestate:cycle()
end

return Options