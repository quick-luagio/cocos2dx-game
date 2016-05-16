
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

---两个导入文件无法修改
require "config"



function __MAIN__TRACKBACK__(msg)
    print("\n\n\n----------------------------------------")
    print("----------------------------------------")
    local errorLog = tostring(msg)
    print("LUA ERROR: " .. tostring(errorLog) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    -- local url = "http://log.ltcs.lodogame.com:9800/api/error_log"
    -- local request = network.createHTTPRequest(function() end,url,kCCHTTPRequestMethodGET)
    -- request:addPOSTValue("msg", debug.traceback("", 2))
    -- request:setTimeout(5)
    -- request:start()
end


local function main()
    cc.game = require("game")
    cc.game.start()
end

local status, msg = xpcall(main, __MAIN__TRACKBACK__)
if not status then
    print(msg)
end


-- local t = {1,"helo",2,"h"}

-- local b = unpack(t)

-- function say(hello,nihao)
--    print(nihao)
-- end

-- say(unpack(t))


-- local tt,c = xpcall(function() local t = 1/0 print(t) end,function() end)

-- print(tt,c)


-- local cc = say()

-- print(cc.name)

-- local kode = {}
-- function kode.getglobal(f)
-- 	local v = _G
-- 	-- for w in string.gfind(f, "[%w_]") do
-- 	for w in string.gmatch(f, "[%w_]+") do
-- 		v = v[w]
-- 	end
-- 	return v
-- end

-- function kode.setglobal(f, v)
-- 	local t = _G
-- 	-- for w, d in string.gfind(f, "([%w_]+)(.?)") do
-- 	for w, d in string.gmatch(f, "([%w_]+)(.?)") do
-- 		if d == "." then -- not last field
-- 			t[w] = t[w] or {}	-- create table if absent
-- 			t = t[w]			-- get the table
-- 		else					-- last field
-- 			t[w] = v 			-- do the assignment
-- 		end
-- 	end
-- end



-- kode.setglobal("hello",123131)


-- print(hello)
-- local  t = {1,2,2,3}

-- function table.indexOf(t, value)
-- 	for k, v in pairs(t) do
-- 		if type(value) == "function" then
-- 			if value(v) then return k end
-- 		else
-- 			if v == value then return k end
-- 		end
-- 	end

-- 	return nil
-- end

-- function table.includes(t, value)
-- 	return table.indexOf(t, value)
-- end

-- function table.unique(t)
-- 	local seen = {}
-- 	for i, v in ipairs(t) do
-- 		if not table.includes(seen, v) then table.insert(seen, v) end
-- 	end

-- 	return seen
-- end

-- t = table.unique(t)

-- for i,v in ipairs(t) do
-- 	print(i,v)
-- end

--print(string.len("",0,1))

-- local function cal(before)
--   collectgarbage("collect")
--   print(before..":"..collectgarbage("count").." k")
-- end

--  local staticKeys = {}

-- local function __STATIC__GET__(name)
--    local keys,list = unpack(require("UserStatic"))
--    package.loaded["UserStatic"] = nil

--    cc[name] = keys
--    return list,function (table,key)
--       return table[cc[name][key]]
--    end
-- end

-- local function loadUser()
--    local list,get = __STATIC__GET__("UserStatic")
   
--    for _,object in ipairs(list) do
   
--    setmetatable(object,{__index=get}
--                )
--    end
--    cal(2)
--    return list
-- end
-- cal(0)
-- local list = loadUser()


-- cal(2)

-- for i=1,5 do
-- 	cal(i)
-- end



-- local function Z(tableStr)
--   return function() return loadstring("return " ..tableStr)() end
-- end
-- cal(1)

-- local t = Z[[{{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},}]]
-- local b = t
-- print(b)
-- cal(2)






