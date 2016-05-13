--[[--
  游戏APP

]]

--require(cc.PACKAGE_APP_CORE..".ConfigManager")


local GameApp = class("GameApp", cc.load("mvc").AppBase)

function GameApp:onCreate()
    math.randomseed(os.time())

    -- facade = GameFacade:getInstance()
    
    -- local module_configs = ConfigManager.getModuleConfig()

    -- facade:loadConfigs(module_configs_)

    -- facade_:registerModules(table.unique(table.keys(module_configs_)))

    --facade:checkEvents()
end


return GameApp
