--[[--
控制器UserController，proxy,view已经注入,可以通过cc.UserProxy访问
只有控制器能够接收和处理消息,同时能够向其他控制器发送消息
]]
local GameController = require(cc.PACKAGE_APP_CORE..".GameController")

local UserController = class("UserController",GameController)




--函数说明
--notification
function UserController:noticeUserProxyGetInfo(notification)

end


return UserController