local GameController = require(cc.PACKAGE_APP_CORE..".GameController")

local LoginController = class("LoginController",GameController)

function LoginController:noticeLoginViewShow(notification)
   cc.loginView:show()
end

function LoginController:noticeLoginProxyLogin(notification)
   cc.loginProxy:login({})
end


return LoginController