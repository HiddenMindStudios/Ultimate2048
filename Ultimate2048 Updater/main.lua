function love.load(args)
  --stored in order of lVer,cVer
  ver = {}
  local version = love.filesystem.newFile("ver")
  version:open("r")
  local data = version:read()
  local iter = 0
  for param in string.gmatch(data, '([^:]+)') do
    iter = iter + 1
    ver[iter] = param
  end
  require("socketHandler")
  ftp = require("socket.ftp")
  upState = 1
  local msg = Socket.encodeData("0:" .. ver[1])
  Socket.send(msg)
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
    --Do stuff
end

function love.update()
  Socket.update(dt)
  if os.time() >= self.msgTime + SOCK_TIMEOUT and self.msgTime > -1 then
    print("Update timeout. Resending...")
    Socket.send(sockMsg)
  end
end

function love.draw()
end