--[[--
视图UserProxy
可以发送消息,与网络接口进行交互
缓存处理，支持http,socket
onRegister，可以向网络接口注册数据推送回调
]]

local GameProxy = require(cc.PACKAGE_APP_CORE..".GameProxy")

local UserProxy = class("UserProxy",GameProxy)

--注册服务器推送
function UserProxy:onRegister()
   
end

return UserProxy