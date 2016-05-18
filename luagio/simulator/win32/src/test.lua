 -- mysql = require "luasql.mysql"

--local str = ":dispose  ("

-- local t= string.find(str,":%s*dispose%s*%(")
-- print(t)
-- for w in t do
--    print(w)
-- end

require("cocos.cocos2d.functions")

-- local str = loadstring("return"..io.readfile("UserStatic.lua"))()

-- print(str[2])


--print(string.len(12))

local ByteArray = require("packages.utils.ByteArray")

local ObjectPool = require("app.core.ObjectPool")

DEBUG = 2

ObjectPool:getInstance():register(ByteArray,1)

-- local byteArray = ObjectPool:getInstance():take("ByteArray")

-- ObjectPool:getInstance():takeBack(byteArray)


-- local byteArray = ObjectPool:getInstance():take("ByteArray")
-- byteArray:setEndian(ByteArray.ENDIAN_LITTLE)
-- byteArray:writeInt(1)
-- byteArray:writeInt(20)

-- byteArray:setPos(1)

-- --ByteArray.ENDIAN_LITTLE = "ENDIAN_LITTLE"
-- --ByteArray.ENDIAN_BIG = "ENDIAN_BIG"

-- byteArray:setEndian(ByteArray.ENDIAN_BIG)
-- print(byteArray:readInt(),byteArray:readInt())

socket = require("socket")

print(socket._VERSION)



-- byteArray:writeInt(13)
-- byteArray:writeStringBytes("Ahello")

-- byteArray:setPos(1)

-- local i = byteArray:readInt()

-- print(i)

-- local s = byteArray:readString(byteArray:getAvailable())


-- print(s)
-- print(byteArray:getAvailable())



-- byteArray:writeUByte(string.byte("h"))

-- byteArray:setPos(1)

-- local t = byteArray:readUByte()

-- print(string.char(t))

-- print(string.byte("helel"))
-- print(string.byte("h"))

-- local __pack = string.pack("<bihP2", 0x59, 11, 1101, "", "中文")

-- print(__pack)

-- local byteArray = ByteArray.new(ByteArray.ENDIAN_LITTLE)
-- byteArray:writeStringBytes(__pack)
-- byteArray:setPos(1)
-- local s = byteArray:readByte()

-- print(s)

