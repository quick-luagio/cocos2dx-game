local socket = require("socket")
require("cocos.cocos2d.functions")
local host = "127.0.0.1"
local port = 12345
local ByteArray = require("packages.utils.ByteArray")
local sock = assert(socket.connect(host, port))
sock:settimeout(0)

local input, recvt, sendt, status

    input = "hello"
    if #input > 0 then
        local buf1 = ByteArray.new()
        buf1:writeStringBytes("hello this lua sock client")
        buf1:setPos(1)
        local t = buf1:readStringBytes(buf1:getAvailable())
        print(t)
        assert(sock:send(t))
    end
    recvt, sendt, status = socket.select({sock}, nil, 1)

    while #recvt > 0 do
        local response, receive_status = sock:receive()

        if receive_status ~= "closed" then
            if response then
                print(response)

                

                recvt, sendt, status = socket.select({sock}, nil, 1)
            end
        else
            break
        end
    end
