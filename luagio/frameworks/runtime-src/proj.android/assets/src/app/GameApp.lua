--[[--
  游戏APP

]]
local GameApp = class("GameApp", cc.load("mvc").AppBase)

function GameApp:onCreate()
    math.randomseed(os.time())
end


local facade_ = kode.facade
facade_:skip(skip_)


-- 加载配置
facade_:loadConfigs(module_configs_)
-- 注册模块观察者
facade_:registerModules(table.unique(table.keys(modules_init_))



-- Event.checkEvents()

function app.model(module, model)
	return facade_:loadModel(module, model)
end

function app.service(module, service)
	return facade_:loadService(module, service)
end

function app.view(module, view)
	return facade_:loadView(module,view)
end

function app.vo(module, vo)
	return facade_:loadvo(module, vo)
end



return GameApp
