local Game = {
  state = "select",
  playStyle = "none"
}
Game.__index = Game

Game.setState = function(self, state, ps, cycle)
  self.state = state
  if ps ~= nil then
    self.playStyle = ps
  end
  if cycle then
    Gamestate:cycle()
  end
end

Game.boardMove = function(self, x, y, xI, yI, board)
  local bChanged = false
  local function moveIter(i, forward)
    if forward == true then
      return i + xI + yI
    else
      return ((i - xI) - yI)
    end
  end
  
  --print("Starting move on tile: (" .. x .. ", " .. y .. ").")
  if board[x][y].val == 0 then
    --print("Skipping tile (" .. x .. ", " .. y .. "), zero tile")
  else
    iter = moveIter(0, true)
    run = true
    while run do
      local tX = xI*xI*iter + x
      local tY = yI*yI*iter + y
      --print("Combine Iterating @ (" .. tX .. ", " .. tY .. ")")
      if tX > 0 and tX <= self.tCount.w and tY > 0 and tY <= self.tCount.h then
        if board[tX][tY].val == board[x][y].val and not board[tX][tY].moved and not board[x][y].moved then
          --print("Combining tile: (" .. x .. ", " .. y .. ") with (" .. tX .. ", " .. tY .. ")")
          board[tX][tY].val = 0
          board[x][y].val = board[x][y].val * 2
          self.score = self.score + board[x][y].val
          board[x][y].moved = true
          bChanged = true
          run = false
          break
        elseif board[tX][tY].val == 0 then
          iter = moveIter(iter, true)
        else
          --print("No combine: " .. board[x][y].val ..  " " .. board[tX][tY].val)
          run = false
          break
        end
      else
        --print("Combine: Out of bounds @ (" .. tX .. ", " .. tY .. ")")
        run = false
        break
      end
    end
    iter = moveIter(0, false)
    run = true
    maxMove = false
    --print("Move Iterating for tile: (" .. x .. ", " .. y .. ")")
    while run do
      local tX = xI*xI*iter + x
      local tY = yI*yI*iter + y
      --print("Move: Checking move tile (" .. tX .. ", " .. tY .. ") from tile (" .. x .. ", " .. y .. ")")            
      if maxMove and not (tX == x and tY == y) then
        --print("Move: Storing tile (" .. x .. ", " .. y .. ") to (" .. tX .. ", " .. tY .. ")")
        board[tX][tY].val = board[x][y].val
        board[x][y].val = 0
        bChanged = true
        break
      elseif maxMove and (tX == x and tY == y) then
        --print("Move: Tile cannot be moved. Leaving")
        break
      end
      if tX <= 0 or tX > self.tCount.w or tY <= 0 or tY > self.tCount.h then
        --print("Move: Out of bounds @ (" .. tX .. ", " .. tY .. ")")
        iter = moveIter(iter, true)
        maxMove = true
      elseif board[tX][tY].val == 0 then
        --print("Move: Found 0 tile")
        iter = moveIter(iter, false)
      else
        --print("Move: Found non-zero tile")
        iter = moveIter(iter, true)
        maxMove = true
      end
    end
  end
  return bChanged
end
  
Game.boardCalculate = function(self, dir, board, xS, xE, yS, yE, xI, yI)
  local boardChanged = false
  if dir == "left" or dir == "right" then
    for y = yS, yE, 1 do
      for x = xS, xE, xI do
        if self:boardMove(x, y, xI, yI, board) == true then
          boardChanged = true
        end
      end
    end
  elseif dir == "up" or dir == "down" then
    for x = xS, xE, 1 do
      for y = yS, yE, yI do
        if self:boardMove(x, y, xI, yI, board) == true then
          boardChanged = true
        end
      end
    end
  end
  for i = 1, self.tCount.w do
    for j = 1, self.tCount.h do
      board[i][j].moved = false
    end
  end
  return boardChanged, board
end

Game.checkMoves = function(self, board)
  for y = 1, self.tCount.h do
    for x = 1, self.tCount.w do
      if board[x][y].val >= 2048 then
        self.counting = false
        self.canMove = false
        return
      end
      if board[x-1] then
        if board[x-1][y].val == 0 or board[x-1][y].val == board[x][y].val then
          return true
        end
      end
      if board[x+1] then
        if board[x+1][y].val == 0 or board[x+1][y].val == board[x][y].val then
          return true
        end
      end
      if y < self.tCount.h then
        if board[x][y+1].val == 0 or board[x][y+1].val == board[x][y].val then
          return true
        end
      end
      if y > 1 then
        if board[x][y-1].val == 0 or board[x][y-1].val == board[x][y].val then
          return true
        end
      end
    end
  end
  return false
end

Game.move = function(self, dir)
  if not self.canMove == true then
    return
  end
  if not self.counting == true then
    self.counting = true
  end
  local yS, yE, xS, xE, xI, yI = 0, 0, 0, 0, 0, 0
  if dir == "left" then
    yS, yE, xS, xE, xI = 1, self.tCount.h, 1, self.tCount.w, 1
  elseif dir == "right" then
    yS, yE, xS, xE, xI = 1, self.tCount.h, self.tCount.w, 1, -1
  elseif dir == "up" then
    yS, yE, xS, xE, yI = 1, self.tCount.h, 1, self.tCount.w, 1
  else
    yS, yE, xS, xE, yI = self.tCount.h, 1, 1, self.tCount.w, -1
  end
  if yS == 0 or yE == 0 or xS == 0 or xE == 0 then
    assert(false, "BAD ENUM")
  end
  print("||Moving board. Dir: " .. dir .. "||")
  changed = false
  changed, self.board = self:boardCalculate(dir, self.board, xS, xE, yS, yE, xI, yI)
  if changed == true then
    self:newPiece()
    self.gMoves = self.gMoves+1
    love.audio.play(self.sound_click)
  else
    self.bMoves = self.bMoves+1
  end
end

Game.pause = function(self)
  self.counting = not self.counting
  self.canMove = not self.canMove
end

Game.newPiece = function(self)
  if self.playStyle ~= "evil" then
    tSpawn = 1
    if self.playStyle == "classic" then
      tSpawn = 4
      if math.random(1, 100) <= 80 then
        tSpawn = 2
      end
    end
    local x, y = math.floor(math.random(1, self.tCount.w)), math.floor(math.random(self.tCount.h))
    if Game.board[x][y].val == 0 then
      Game.board[x][y].val = tSpawn
    else
      Game:newPiece()
    end
  end
end

Game.timerToString = function(self)
  local min, sec, ms = 0, 0, 0
  local mP, sP, msP = "", "", ""
  min = self.timer/60 - ((self.timer%60)/60)
  sec = math.floor(self.timer-min*60)
  ms = round(self.timer - min*60 - sec, 2) * 100
  if min < 10 then mP = "0" end
  if sec < 10 then sP = "0" end
  if ms < 10 then msP = "0" end
  return mP .. tostring(min) .. ":" .. sP .. tostring(sec) .. "." .. msP .. tostring(ms)
end

Game.reset = function(self)
  self.board = {}
  self.timer = 0
  self.gMoves = 0
  self.bMoves = 0
  self.canMove = true
  self.counting = false
  self.score = 0
end

Game.init = function(self, w, h)
  self:reset()
  self.w = w
  self.h = h
  self.sound_click = love.audio.newSource(_Assets_audio_click)
  if self.state == "select" then
    local btnW, btnH = w*.3, h*.16875
    local btnPctX, btnPctY = btnW/imgSize.buttonSize.w, btnH/imgSize.buttonSize.h
    local btnSpace = 1*btnH
    local btnX = (w-btnW)/2
    local btnBaseY = (h-btnH)/2 - h*.1
    
    local cscY = btnBaseY
    local cscFxn = function(self)
      Game:setState("play", "classic", true)
    end
    Gamestate.UI[1] = button.new("game_classic", btnX, cscY, btnW, btnH, btnPctX, btnPctY, cscFxn, nil, nil)
    
    local clmbY = cscY + 1*btnH
    local clmbFxn = function(self)
      Game:setState("play", "climb", true)
    end
    Gamestate.UI[2] = button.new("game_climb", btnX, clmbY, btnW, btnH, btnPctX, btnPctY, clmbFxn, nil, nil)
  elseif self.state == "play" then
    self.maxGrid = _settings["gridSize"]/100 * self.h*.7
    self.tCount = {w = _settings["tileCountW"], h = _settings["tileCountH"]}
    for i = 1, self.tCount.w do
      self.board[i] = {}
      for j = 1, self.tCount.h do
        self.board[i][j] = Tile.new(0)
      end
    end
    self.sizeW = self.maxGrid/self.tCount.w
    self.sizeH = self.maxGrid/self.tCount.h
    if _settings.gridOutline == 1 then
      self.gridW = self.sizeW % math.floor(self.sizeW) / self.tCount.w
      if self.gridW < 1 then
        self.sizeW = self.sizeW - self.tCount.w
        self.gridW = self.tCount.w
      end
      self.gridH = self.sizeH % math.floor(self.sizeH) / self.tCount.h
      if self.gridH < 1 then
        self.sizeH = self.sizeH - self.tCount.h
        self.gridH = self.tCount.h
      end
    else
      self.gridW = 0
      self.gridH = 0
    end
    self:newPiece()
    self:newPiece()
  end
end

Game.update = function(self, dt)
  if self.counting == true then
    self.timer = self.timer+dt
    if not self:checkMoves(self.board) then
      self.counting, self.canMove = false, false
    end
  end
end

Game.keypressed = function(self, key)
end

Game.draw = function(self)
  love.graphics.print(self.state .. ":" .. self.playStyle, 0, 12)
  if self.state == "play" then
    local mG = self.maxGrid
    --Draw the tiles
    for x=1, self.tCount.w do
      for y=1, self.tCount.h do
        local tX = (x-1)*self.sizeW + x*self.gridW
        local tY = (y-1)*self.sizeH + y*self.gridH
        local c = tileColorTables[_settings.tileColorScheme][self.board[x][y].val]
        if c == nil then
          if self.board[x][y].val > 2048 then
            c = tileColorTables[_settings.tileColorScheme]["big"]
          else
            assert(false, self.board[x][y].val)
          end
        end
        love.graphics.setColor(c)
        love.graphics.rectangle("fill", tX, tY, self.sizeW, self.sizeH)
        love.graphics.setColor(255,255,255,255)
        if self.board[x][y].val > 0 then
          Font.setFont("std", math.ceil(.25*self.sizeW))
          local nX = tX + .5*self.sizeW - .5*Font.getWidthOfText(self.board[x][y].val)
          local nY = tY + .5*self.sizeH - .5*Font.getHeightOfText(self.board[x][y].val)
          love.graphics.print(self.board[x][y].val, nX, nY)
          Font.resetFont()
        end
      end
    end
    --Big box
    love.graphics.rectangle("line", 0, 0, mG, mG)
    i = 1
    --Grid
    if _settings.gridOutline == 1 then
      while i <= self.tCount.w do
        love.graphics.rectangle("fill", (i-1)*self.sizeW + (i-1)*self.gridW, 0, self.gridW, mG)
        i = i + 1
      end
      i = 1
      while i <= self.tCount.h do
        love.graphics.rectangle("fill", 0, (i-1)*self.sizeH + (i-1)*self.gridH, mG, self.gridH)
        i = i + 1
      end
    end
    --Grid Border
    local bGM = self.h*.7
    love.graphics.setColor(255,255,255,255)
    --Timer + moveCount Box
    Font.setFont("std", math.ceil(.10*self.h))
    local text = self:timerToString()
    local nx = bGM + (self.h*.1)
    local ny = .5*Font.getHeightOfText(text)
    local _w = self.h*.4
    love.graphics.print(text, nx, ny)
    local _y = Font.getHeightOfText(text) + ny + .01*self.h
    love.graphics.rectangle("line", nx, _y, _w, bGM - _y)
    Font.resetFont()
    --Move counts and scores
    local mpct = (round(self.gMoves/(math.max(self.bMoves+self.gMoves, 1)),2)*100)
    local mps = round((self.bMoves+self.gMoves)/math.max(self.timer, 1), 2)
    local s = math.floor((self.score - self.bMoves*10)*(round(self.gMoves/math.max(self.bMoves+self.gMoves, 1), 2)))
    Font.setFont("std", .1*_w)
    nx = nx + .01*self.h*.3
    love.graphics.print("Good Moves: " .. self.gMoves, nx, _y + .01*self.h)
    love.graphics.print("Bad Moves: " .. self.bMoves, nx, _y + .02*self.h + Font.getHeightOfText(text))
    love.graphics.print("Total Moves: " .. self.bMoves+self.gMoves, nx, _y + .03*self.h + 2*Font.getHeightOfText(text))
    love.graphics.print("Moves%: " .. mpct, nx, _y + .04*self.h + 3*Font.getHeightOfText(text))
    love.graphics.print("Moves/sec: " .. mps, nx, _y + .05*self.h + 4*Font.getHeightOfText(text))
    love.graphics.print("Score: " .. s, nx, _y + .06*self.h + 5*Font.getHeightOfText(text))
    Font.resetFont()
  end
end

return Game