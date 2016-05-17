--[[--
  游戏APP

]]

require(cc.PACKAGE_UTILS..".var")
require(cc.PACKAGE_APP_CORE..".Helper")


local AppBase = require(cc.PACKAGE_MVC..".AppBase")

local GameApp = class("GameApp", AppBase)

function GameApp:ctor()
   local configs = {
                      defaultScene = "MainScene",
                      scene_package = cc.PACKAGE_APP_SCENES
                   }
    GameApp.super.ctor(self,configs)
end

--初始化app
function GameApp:initApp()
    local module_configs = cc.cmg.getModuleConfig() --获取模块配置文件

    cc.facade:loadConfigs(module_configs) --载入模块配置文件

    cc.facade:registerModules(table.unique(table.keys(module_configs))) --facade注册模块

    cc.facade:send(cc.events.Login_Proxy_Login)

    -- cc.facade:checkEvents()
end


--注入处理
function GameApp:inject()
    cc.cmg = require(cc.PACKAGE_APP_CORE..".ConfigManager") --导入配置管理

    cc.mvc = require(cc.PACKAGE_MVC..".init")  --导入mvc库

    cc.mvc.modulePath = cc.PACKAGE_APP_MODULES --设置模块路径

    cc.events = require(cc.PACKAGE_APP_CONFIG..".Events") --获取events
    
    cc.paths = require(cc.PACKAGE_APP_CONFIG..".Paths") -- 获取资源路径

    cc.viewTypes = require(cc.PACKAGE_APP_CONFIG..".ViewTypes") -- 获取视图类型

    cc.facade = require(cc.PACKAGE_APP_CORE..".GameFacade"):getInstance() -- 获取facade实例

    cc.viewMonitor = require(cc.PACKAGE_APP_CORE..".ViewMonitor"):getInstance() -- 获取视图管理监控实例
end



--当app注册时
function GameApp:onRegister()
    math.randomseed(os.time())
    self:inject()
    self:initApp()
end


--进入场景
function GameApp:enterScene(sceneName, transition, time, more)
    local scene = GameApp.super.enterScene(self,sceneName, transition, time, more)
    cc.viewMonitor:replaceScene(scene) --视图监控器切换场景[暂时做简单处理]
    return scene
end

return GameApp
