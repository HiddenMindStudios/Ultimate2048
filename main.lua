function settingsLoader(t)
  for k, v in pairs(t) do
    if k == "gridSize" then
      v = tonumber(v)
      if v < _settingsMin[k] or v > _settingsMax[k] then
        v = 80
      end
    elseif k == "tileCountW" then
      v = tonumber(v)
      if v < _settingsMin[k] or v > _settingsMax[k] then
        v = 4  
      end
    elseif k == "tileCountH" then
      v = tonumber(v)
      if v < _settingsMin[k] or v > _settingsMax[k] then
        v = 4
      end
    elseif k == "tileColorScheme" then
      v = tostring(v)
      local pass = false
      for _, col in ipairs(tileColors) do
        if col == v then
          pass = true
        end
      end
      if not pass then
        v = tileColors[1]
      end
    elseif k == "fullscreenType" then
      if v ~= "desktop" and v ~= "exclusive" then
        v = "desktop"
      end
    elseif k == "monitor" then
      v = tonumber(v)
      if v < 1 or v > love.window.getDisplayCount() then
        v = 1
      end
    elseif k == "gridOutline" or k == "tileAnimations" or k == "fullscreen" or k == "vsync" or k == "sound" or k == "music" then
      v = tonumber(v)
      if v ~= 0 and v ~= 1 then
        v = 1
      end
    elseif k == "volumeMusic" or k == "volumeSound" then
      v = tonumber(v)
      if v < 0 or v > 1 then
        v = 1
      end
    end
    if k ~= "w" or k ~= "h" then
      _settings[k] = v
    end
  end
  _data.resLoad()
  print("Dim Check")
  w = 0
  h = 0
  goodDim = false
  for _, dim in ipairs(ScreenModes) do
    if dim.width == (tonumber(t.w)) and dim.height == (tonumber(t.h)) then
      print("goodDim")
      goodDim = true
      _settings.w = t.w
      _settings.h = t.h
      break
    end
  end
  if not goodDim then
    dim = ScreenModes[#ScreenModes]
    print("Bad Dim: Setting to " .. dim.width .. "x" .. dim.height)
    _settings.w, _settings.h = dim.width, dim.height
  end
  local _,_, f = love.window.getMode()
  if _settings.fullscreen == 1 then
    f.fullscreen = true
  else
    f.fullscreen = false
  end
  f.vsync = _settings.vsync
  f.display = _settings.monitor
  f.fullscreentype = _settings.fullscreenType
  love.window.setMode(_settings.w,_settings.h, f)
end

function love.load()
  require("load")
  sLoad = {}
  local sF = love.filesystem.newFile("settings.txt")
  if not love.filesystem.isFile("settings.txt")then
    sF:open("w")
    sLoad = tableToText(require("settings"))
    local test = sF:write(sLoad)
    if not test then
      --Probably should do something here....
    end
    sF:close()
  end
  sF:open("r")
  dat = sF:read()
  sLoad = textToTable(dat)
  settingsLoader(sLoad)
  math.randomseed(os.time())
  Gamestate:set("start")
end

function love.update(dt)
  Gamestate:update(dt)
end

function love.mousereleased(x, y, btn)
  Gamestate:mousereleased(x,y,btn)
end

function love.keypressed(key)
  Gamestate:keypressed(key)
end

function love.keyreleased(key)
  Gamestate:keyreleased(key)
end

function love.draw()
  local w, h = love.graphics.getDimensions()
  Gamestate:draw()
  love.graphics.print(w .. "x" .. h, 0, 24)
end