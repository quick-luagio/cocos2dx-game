local game = {}

--游戏开始
function game.start()
	xpcall(function()  game.unloadPackage()  game.loadPackage() end,function(msg) print(msg) end)
	
    require("app.GameApp").new():run()
end

function game.loadPackage()
   require"packages.lua" 
   require "cocos.init" 
end

--清理pakage
function game.unloadPackage()
    require("luaLoader")
end


function game.exit()
    os.exit()
end


return game
