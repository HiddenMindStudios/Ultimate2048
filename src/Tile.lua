Tile = {}
Tile.__index = Tile
Tile.__class = "tile"

Tile.new = function(value)
  local t = {}
  setmetatable(t, Tile)
  t.val = value
  t.moved = false
  return t
end