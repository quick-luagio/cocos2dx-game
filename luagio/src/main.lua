
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

print(string.len("",0,1))









