_data = {}
_settings = {}
imgSize = {
	buttonSize = {w = 1920, h = 1080},
  splash = { w = 1920, h = 1080}
}
tileColors = {
  "classic"
}
_ANIMSIZE = 64


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

function _data.init()
  ScreenModes = love.window.getFullscreenModes()
end

_data.init()