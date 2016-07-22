Socket = {}
Socket.__index = Socket
SOCK_TIMEOUT = 30

SockTypeEnum = {
  firstConn = 0,
  login = 1,
  ping = 2
}

Socket.init = function()
	Socket.s = require "socket"
	Socket.addr = "73.75.82.97"
	Socket.port = 2048
	Socket.uTime = .1
	Socket.nTime = 0
	local sock = Socket.s.udp()
	sock:settimeout(0)
	sock:setpeername(Socket.addr, Socket.port)
	Socket.sock = sock
end

Socket.send = function(data)
  sockMsg = data
  msgTime = os.time()
	Socket.sock:send(data)
  print("Sent " .. data)
end

Socket.update = function(dt)
	Socket.nTime = Socket.nTime + dt
	if Socket.nTime >= Socket.uTime then
		Socket.nTime = Socket.nTime - Socket.uTime
		repeat
			data, msg = Socket.sock:receive()
			if data then
        data = base64.decode(data)
				Socket.passData(data)
			end
		until not data
	end
end

Socket.passData = function(data, msg)
  params = {}
  iter = 0
  for param in string.gmatch(data, '([^:]+)') do
    iter = iter + 1
    params[iter] = param
  end
  newData(params)
end

Socket.encodeData = function(data)
  return base64.encode(data)
end
Socket.init()