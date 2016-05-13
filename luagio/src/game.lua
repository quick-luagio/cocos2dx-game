local Game = {}

--游戏开始
function Game.start()
	xpcall(function()  Game.packageUnload()  require "cocos.init"  end,function(msg) print(msg) end)
	
    require("app.GameApp"):create():run()
end


--清理pakage
function Game.packageUnload()

end


function Game.exit()
    os.exit()
end


return Game
