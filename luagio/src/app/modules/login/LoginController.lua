local GameController = require(cc.PACKAGE_APP_CORE..".GameController")

local LoginController = class("LoginController",GameController)

function LoginController:noticeLoginViewShow(notification)
   print("receive:",notification.name)
end

function LoginController:noticeLoginProxyLogin(notification)
   print("receive:",notification.name)
   cc.loginProxy:login({})
end


return LoginController