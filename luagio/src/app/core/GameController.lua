--[[--
游戏模块控制器

]]

local GameController = class("GameController",cc.mvc.Controller)

-- register view and proxy setglobal
function GameController:onRegister()
   printInfo("[%s], [%s] onRegister",self.moduleName,self.__cname)
   GameController.super.onRegister(self)

   local module_configs = cc.facade:getConfigs()
   local module_config  = module_configs[self.moduleName]

   local views = module_config["views"]
   local proxys = module_config["proxys"]
   
   for _,view in ipairs(views) do
   	local view = cc.facade:loadView(self.moduleName,view)
	   if view then setglobal(checkObjName(view.__cname), view) end
   end

   if not proxys then
      proxys = {self.moduleName.."Proxy"}
   end
   for _,proxy in ipairs(proxys) do
   	local proxy = cc.facade:loadProxy(self.moduleName,proxy)
   	if proxy then setglobal(checkObjName(proxy.__cname),proxy) end
   end
   
end

-- GameController remove setglobal nil
function GameController:onRemove()
   GameController.super.onRemove(self)
   printInfo("[%s] onRemove",self.__cname)

   local module_configs = facade:getConfigs()
   local module_config  = module_configs[self.moduleName]

   local views = module_config["views"]
   local proxys = module_config["proxys"]
   
   for _,view in ipairs(views) do
   	local view = facade:loadView(self.moduleName,view)
	   if view then setglobal(checkObjName(view.__cname), nil) end
   end
   
   if not proxys then
      proxys = {self.moduleName.."Proxy"}
   end

   for _,proxy in ipairs(proxys) do
   	   local proxy = facade:loadProxy(self.moduleName,proxy)
   	   if proxy then setglobal(checkObjName(proxy.__cname),nil) end
   end
end



return GameController