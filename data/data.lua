_data = {}
_settings = {}
imgSize = {
	buttonSize = {w = 1920, h = 1080},
  splash = { w = 1920, h = 1080},
  square = { w = 1920, h = 1080}
}

tileColors = {
  "classic"
}

_settingsMin = {
  gridSize = 50,
  tileCountW = 2,
  tileCountH = 2
}

_settingsMax = {
  gridSize = 100,
  tileCountW = 10,
  tileCountH = 10
}


tileColorTables = {
  classic = {
    cType = "color",
    [0] = {125, 125, 125, 130},
    [1] = {238, 228, 218, 090},
    [2] = {238, 228, 218, 255},
    [4] = {237, 224, 200, 255},
    [8] = {242, 177, 121, 255},
   [16] = {245, 149, 099, 255},
   [32] = {246, 124, 095, 255},
   [64] = {246, 094, 059, 255},
  [128] = {237, 207, 114, 255},
  [256] = {237, 204, 097, 255},
  [512] = {237, 200, 080, 255},
 [1024] = {237, 194, 046, 255},
 [2048] = {225, 038, 225, 225},
  big = {000, 000, 000, 255}
  }
}
ScreenModes = {}

function _data.resLoad()
  local w, h, f = love.window.getMode()
  local m = _settings.monitor or 1
  ScreenModes = love.window.getFullscreenModes(m)
  table.sort(ScreenModes, function(a,b) return a.width*a.height < b.width*b.height end)
  local gDim = false
  for k, v in ipairs(ScreenModes) do
    if v.width == w and v.height == h then
      gDim = true
    end
  end
  if not gDim then
    love.window.setMode(ScreenModes[#ScreenModes].width, ScreenModes[#Screenmodes].height, f)
  end
  print("Total of " .. #ScreenModes .. " dimensions.")
end

function _data.init()
  _data.resLoad()
end

_data.init()