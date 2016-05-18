local socket = require("socket")
require("cocos.cocos2d.functions")
local host = "127.0.0.1"
local port = "12345"
print("say")
local server = assert(socket.bind(host, port, 1024))

server:settimeout(0)

local client_tab = {}
local conn_count = 0

local ByteArray = require("packages.utils.ByteArray")
print("Server Start "  .. host .. ":" .. port) 


function listenClient()
    local conn = server:accept()

    if conn then
        conn_count = conn_count + 1
        client_tab[conn_count] = conn
        print("A client successfully connect!") 
    end

    for conn_count, client in pairs(client_tab) do
        local recvt, sendt, status = socket.select({client}, nil, 1)

        if #recvt > 0 then
            local receive, receive_status = client:receive()

            print("from client:",receive)

            if receive_status ~= "closed" then
                if receive then
                    assert(client:send("Client "  .. conn_count .. " Send : "))
                    assert(client:send(receive .. "\n"))
                    print("Receive Client "  .. conn_count .. " : ", receive)   

                end
            else

                table.remove(client_tab, conn_count) 
                client:close() 
                print("Client "  .. conn_count .. " disconnect!") 

            end
        end
    end
end




