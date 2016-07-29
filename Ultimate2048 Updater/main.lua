function love.load(args)
  --stored in order of lVer,cVer
  require("font")
  require("src/base64")
  require("src/bit")
  assert(bit.btest1, "FAIL1")
  assert(bit.btest2, "FAIL2")
  Font.setFont("std", 40)
  ver = {}
  async = require('async')
  async.load(2)
  local version = love.filesystem.newFile("ver")
  if not love.filesystem.exists("ver") then
    ver[1] = "0.0"
    ver[2] = "0.0"
  else
    version:open("r")
    local data = version:read()
    local iter = 0
    for param in string.gmatch(data, '([^:]+)') do
      iter = iter + 1
      ver[iter] = param
    end
  end
  require("socketHandler")
  ftp = require("socket.ftp")
  upState = 1
  local msg = Socket.encodeData("0:" .. "Launch:" .. ver[1])
  Socket.send(msg)
end

function requestUpdate(params, file)
  local bin = ""
  local ftpCon = {
    host = params[4],
    path = file,
    user = params[5],
    password = params[6],
    port = params[7]
  }
  upState = 2
  downloader = async.define("download", function()
      local bin, e = ftp.get(ftpCon)
      return bin, e
    end)
  local b, e = downloader()
  assert(b, e)
end

function newData(params)
  if params[1] == "0" and params[3] == "Update" then
    if params[2] == "Launch" then
      dataFile = "Ultimate2048Launcher.exe"
    else
      dataFile = "Ultimate2048.exe"
    end
    requestUpdate(dataFile, params)
  else
    if params[1] ~= 0 then
      print ("Bad Response!")
      return
    elseif params[3] == "NoUpdate" then
      print("Up to date")
      --download ver file
    end
  end
end

function love.update(dt)
  Socket.update(dt)
  if os.time() >= msgTime + SOCK_TIMEOUT and msgTime > -1 then
    print("Update timeout. Resending...")
    Socket.send(sockMsg)
  end
end

function love.draw()
  local w,h = love.graphics.getDimensions()
  local cx, cy = (w-600)/2, (h-200)/2
  love.window.setPosition(cx, cy)
  local s = ""
  if upState == 1 then
    s = "Verifying Version..."
  elseif upState == 2 then
    s = "Downloading Update..."
  elseif upstate == 3 then
    s = "Update Complete."
  end
  local x = (600-Font.getWidthOfText(s))/2
  local y = (200-Font.getHeightOfText(2))/2
  love.graphics.print(s, x, y)
end