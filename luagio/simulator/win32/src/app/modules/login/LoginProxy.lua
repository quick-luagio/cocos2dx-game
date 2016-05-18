local GameProxy = require(cc.PACKAGE_APP_CORE..".GameProxy")

local LoginProxy = class("LoginProxy",GameProxy)

function LoginProxy:login(askInfo)
   print("LoginProxy","ask")
   self:send(cc.events.Login_View_Show)
end

return LoginProxy