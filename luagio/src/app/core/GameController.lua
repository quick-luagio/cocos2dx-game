local GameController = class("GameController")

function GameController:getProxy(name)
  -- return game.getglobal(name)
end

function GameController:getView(name)
   return 
end

-- register view and proxy setglobal
function GameController:onRegister()
   GameController.super.onRegister()
   local module_configs = facade:getConfigs()
   local module_config  = game.checkLazy(module_configs[self.moduleName])

   local views = game.checkLazy(module_config["views"])
   local proxys = game.checkLazy(module_config["proxys"])
   
   for _,view in ipairs(views) do
   	   local view = facade:loadView(moduleName,view)
   	   
	   if view then game.setglobal(game.checkObjName(view.__cname), view) end
   end

   for _,proxy in ipairs(proxys) do
   	   local proxy = facade:loadProxy(moduleName,proxy)
   	   if proxy then game.setglobal(game.checkObjName(proxy.__cname),proxy)
   end
   
end


-- GameController remove setglobal nil
function GameController:onRemove()
   GameController.super.onRemove()
   local module_configs = facade:getConfigs()
   local module_config  = game.checkLazy(module_configs[self.moduleName])

   local views = game.checkLazy(module_config["views"])
   local proxys = game.checkLazy(module_config["proxys"])
   
   for _,view in ipairs(views) do
   	   local view = facade:loadView(moduleName,view)
   	   
	   if view then game.setglobal(game.checkObjName(view.__cname), nil) end
   end

   for _,proxy in ipairs(proxys) do
   	   local proxy = facade:loadProxy(moduleName,proxy)
   	   if proxy then game.setglobal(game.checkObjName(proxy.__cname),nil)
   end
end

return GameController