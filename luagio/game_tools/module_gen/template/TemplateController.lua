--[[--
控制器TemplateController，proxy,view已经注入,可以通过cc.templateProxy访问
只有控制器能够接收和处理消息,同时能够向其他控制器发送消息
]]
local GameController = require(cc.PACKAGE_APP_CORE..".GameController")

local TemplateController = class("TemplateController",GameController)




return TemplateController