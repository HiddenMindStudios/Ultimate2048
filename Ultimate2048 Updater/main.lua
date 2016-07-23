function love.load(args)
  --stored in order of lVer,cVer
  require("font")
  require("base64")
  require("bit")
  assert(bit.blshift, "Bad")
  Font.setFont("std", 12)
  ver = {}
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
  local msg = Socket.encodeData("0:" .. ver[1])
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
  bin, e = ftp.get(ftpCon)
  assert(bin ~= nil, e)
end

function newData(params)
  if params[1] == "0" and params[3] == "Update" then
    if params[2] == "Launch" then
      dataFile = "Ultimate2048Launcher.exe"
    else
      dataFile = "Ultimate2048.exe"
    end
    requestFile(dataFile, params)
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

function love.update()
  Socket.update(dt)
  if os.time() >= self.msgTime + SOCK_TIMEOUT and self.msgTime > -1 then
    print("Update timeout. Resending...")
    Socket.send(sockMsg)
  end
end

function love.draw()
  local s = ""
  if upState == 1 then
    s = "Verifying Version..."
  elseif upState == 2 then
    s = "Downloading Update..."
  elseif upstate == 3 then
    s = "Update Complete."
  end
  local x = (w-Font.getWidthOfText(s))/2
  love.graphics.print(s, x, 0)
end