function _deepTable(t)
  local rS = ""
  for k, v in pairs(t) do
    if type(v) == "table" then
      rS = rS .. _deepTable(v)
    else
      rS = rS .. k .. "=" .. v .. "\r\n"
    end
  end
  return rS
end

function tableToText(t)
  return _deepTable(t)
end

function _textToTable(t)
  local r = {}
  for k, v in pairs(t) do
    print(k .. ":" .. v)
  end
end

function saveSettings()
  local sF = love.filesystem.newFile("settings.txt")
  sF:open("w")
  sLoad = tableToText(_settings)
  local test = sF:write(sLoad)
  if not test then
    --Probably should do something here
  end
  sF:close()
end

function updateResolution()
  local _, _, f = love.window.getMode()
  if _settings.vsync == 1 then
    f.vsync = true
  else
    f.vsync = false
  end
  f.display = _settings.monitor
  if _settings.fullscreen == 1 then
    f.fullscreen = true
  else
    f.fullscreen = false
  end
  f.fullscreentype = _settings.fullscreenType
  _data.resLoad()
  love.window.setMode(_settings.w, _settings.h, f)
  saveSettings()
end

function textToTable(str)
  local r = {}
  local function helper(line) 
    local e = line:find("=")
    if e == nil then
      return nil
    else
      key = line:sub(1, e-1)
      val = line:sub(e+1, line:len())
      if type(val) ~= "table" or type(val) ~= "function" then
        r[key] =val
      end
    end
    return "" 
  end
  helper((str:gsub("[^\r\n]+", helper)))
  return r
end

function round(num, idp)
  local mult = 10 ^(idp or 0)
  return math.floor(num*mult +0.5)/mult
end