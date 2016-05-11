
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


local cc = say()

print(cc.name)