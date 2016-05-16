--[[--
视图TemplateProxy
可以发送消息,与网络接口进行交互
缓存处理，支持http,socket
onRegister，可以向网络接口注册数据推送回调
]]

local GameProxy = require(cc.PACKAGE_APP_CORE..".GameProxy")

local TemplateProxy = class("TemplateProxy",GameProxy)

--注册服务器推送
function TemplateProxy:onRegister()
   
end

return TemplateProxy