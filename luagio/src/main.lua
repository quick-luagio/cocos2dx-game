
-- cc.FileUtils:getInstance():setPopupNotify(false)
-- cc.FileUtils:getInstance():addSearchPath("src/")
-- cc.FileUtils:getInstance():addSearchPath("res/")

-- require "config"
-- require "cocos.init"

-- local function main()
--     require("app.MyApp"):create():run()
-- end

-- local status, msg = xpcall(main, __G__TRACKBACK__)
-- if not status then
--     print(msg)
-- end


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
local t  = "LOGIN"
local tt = string.find(t,"_")

print(tt)
--local b = string.sub("LOGIN_Hello_ddd",0,string.find(t,"_")-1)


print(b)



