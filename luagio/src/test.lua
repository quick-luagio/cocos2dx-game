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

local byteArray = ByteArray.new(ByteArray.ENDIAN_LITTLE)
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

print(string.byte("helel"))
print(string.byte("h"))

local __pack = string.pack("<bihP2", 0x59, 11, 1101, "", "中文")

print(__pack)

local byteArray = ByteArray.new(ByteArray.ENDIAN_LITTLE)
byteArray:writeStringBytes(__pack)
byteArray:setPos(1)
local s = byteArray:readByte()

print(s)

