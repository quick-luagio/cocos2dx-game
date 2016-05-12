
local eventListeners_ = {}

function Event.getListeners(module)
	local listenerFunc_ = eventListeners_[module]
	if listenerFunc_ then
		return listenerFunc_()
	else
		lualog("module [%s] has no controller", module)
		return nil
	end
end

-- Lazy loading
function Event.register(module, events)
	if module and events then
		eventListeners_[module] = events
	else
		error("Event.register failed, module or events is nil")
	end
end

function Event.checkEvents()
	local events
	for module, eventFunc in pairs(eventListeners_) do
		events = eventFunc()
		if istable(events) and #events > 0 then
			local eventName, prev
			for i = 1, #events do
				eventName = events[i]
				if not ((isstring(eventName) and eventName ~= "") or isnumber(eventName)) then
					prev = i - 1
					if prev < 1 then prev = 1 end
					puts("[%s_e.lua id:%s] event name is empty (prev %s)]", module, i, events[prev])
					-- error(sputs("[%s_e.lua id:%s] event name is empty (prev %s)]", module, i, events[prev]))
				end
			end
		end
	end
end

--[[
class facade
--]]
local Facade = class("Facade")

function Facade:ctor()
    self.observerMap_ = {},
	self.loadedModules_ = {},
	self.skippedModules_ = {}
end

function Facade:getInstance()
    if not self._instance then
       self._instance = Facade.new() 
    end
    return self._instance
end


function Facade:registerEvents(module,events)
   Event.register(module, events)
end 

function Facade:registerObserver(eventName, observer)
	if not eventName then
		error("facade:registerObserver: eventName is empty")
		return
	end
	if self.observerMap_[eventName] == nil then
		self.observerMap_[eventName] = {observer}
	else
		table.insert(self.observerMap_[eventName], observer)
	end
end

function Facade:notifyObservers(event)
	local observers = nil 

	if self.observerMap_[event.name] then
		observers = self.observerMap_[event.name]
		for _, observer in ipairs(observers) do
			if self.loadedModules_[observer.name] == nil then
				self:loadModule(observer.name)
			end
			observer:setContext(self.loadedModules_[observer.name])
			observer:notifyObserver(event)
		end
	end
end

function Facade:send(eventName, ...)
	body = select(1, ...) or {}
	type_ = select(2, ...) or "nil"
	-- puts("send: name=%s, body=%s, type=%s", eventName, game.tostring(body), type_)
	self:notifyObservers({name=eventName, body=body, type=type_})
end

function Facade:registerModules(modules)
	modules = table.unique(modules)
	for _, v in ipairs(modules) do
		if v then
			self:registerModule(v)
		end
	end
end

function Facade:registerModule(module)
	self:loadEvent(v)

	local listeners_ = Event.getListeners(module)
	local observer_
	if listeners_ and #listeners_ > 0 then
		observer_ = Observer.new(module,"handleNotification")
		for _, eventName in ipairs(listeners_) do
			self:registerObserver(eventName, observer_)
		end
	end
end

function Facade:skip(modules)
	if istable(modules) then
		for module, value in pairs(modules) do
			self.skippedModules_[module] = {m = value[1], s = value[2]}
		end
	end
end

function Facade:getModulePath(module)
	return format("%s.%s.%s", game.appPath, game.modulePath, module)
end

function Facade:loadController(module, controller)
	local controller_ = controller or module
	local pkg_ = format("%s.%sController", self:getModulePath(module), controller_)
	local obj_ = require(pkg_).new(module)

	return obj_
end

function Facade:loadModel(module, model)
	local model_ = model or module
	local pkg_ = format("%s.%sModel", self:getModulePath(module), model_)
	local obj_ = require(pkg_).new()

	return obj_
end

function Facade:loadProxy(module, proxy)
	local proxy_ = proxy or module
	local pkg_ = format("%s.%sProxy", self:getModulePath(module), proxy_)
	local obj_ = require(pkg_).new()

	return obj_
end

function Facade:loadView(module, view)
	local view_ = view or module
	local pkg_ = format("%s.%sView", self:getModulePath(module), view_)
	local obj_ = require(pkg_).new()

	return obj_,pkg_
end

function Facade:loadVo(module, vo)
	local vo_ = vo or module
	local pkg_ = format("%s.%sVo", self:getModulePath(module), vo_)
	local obj_ = require(pkg_).new()

	return obj_
end

function Facade:loadEvent(module, event)
	local event_ = event or module
	local pkg_ = format("%s.%sEvent", self:getModulePath(module), event_)
	
	require(pkg_)
end

function Facade:loadModule(module)
	if self.loadedModules_[module]  then
       printInfo(module.."has loaded before,plz check")
       return
	end
	local controller = self:loadController(module)
	assert(controller ~= nil, module .. " controller must be not nil")
	
	self.loadedModules_[module] = controller
	controller:onRegister()

	-- if not self.skippedModules_[module] or not self.skippedModules_[module]["m"] then
	-- 	local model_ = self:loadModel(module)
	-- 	if model_ then game.setglobal(module .. "Model", self:loadModel(module)) end
	-- end

	-- if not self.skippedModules_[module] or not self.skippedModules_[module]["s"] then
	-- 	local service_ = self:loadService(module)
	-- 	if service_ then game.setglobal(module .. "Service", self:loadService(module)) end
	-- end
end




--[[
class notifier
--]]


local Notifier = class("Notifier")

function Notifier:send(name, body, type_)
	facade:send(name, body, type_)
end




--[[
class observer
--]]


local Observer = class("Observer")

function Observer:ctor()
    self.notify = ""
	self.name = ""
	self.context = {}
end

function Observer:setContext(context)
	self.context = context
end

function Observer:notifyObserver(event)
	self.context[self.notify](self.context, event)
end

function Observer:compareNotifyContext(object)
	return object == self.context
end

--[[
class controller
--]]

local Controller = class("Controller",Notifier)

function Controller:ctor(moduleName)
	self.moduleName = moduleName
end



function Controller:onRegister()
end

function Controller:onRemove()
end

function Controller:handleNotification(notification)
	if notification.name then
		local action = "action_" .. notification.name .. "_"
		if self[action] and isfunction(self[action]) then
			self[action](self, notification)
		end
		
		if self.message then
			local name = notification.name
			if self.message[name] and isfunction(self.message[name]) then
				self.message[name](self,notification)
			end
		end 
	end
end


local View = class("View",Notifier)

local Proxy = class("Proxy",Notifier)

local Model = class("Model",Notifier)


