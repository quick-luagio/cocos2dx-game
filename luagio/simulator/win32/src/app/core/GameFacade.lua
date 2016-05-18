--[[--
游戏模块控制中心

]]

local GameFacade = class("GameFacade",cc.mvc.Facade)

function GameFacade:loadConfigs(module_configs)
   self.module_configs = module_configs
   for module,config in pairs(module_configs) do
   	   self:registerEvents(module,config.events)
   end
end

function GameFacade:getConfigs()
   return self.module_configs
end




return GameFacade

