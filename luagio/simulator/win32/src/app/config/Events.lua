--[[--
   事件配置文件
   facade 能够处理 三类事件
   ---- 命名方式  proxy(view)_methodName ，第一个模块名必须保证
]]

local events = {}

events.Login_Proxy_Login = "Login_Proxy_Login"

events.Login_View_Show = "Login_View_Show"

return events

