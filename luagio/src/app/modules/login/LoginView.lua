local GameView = require(cc.PACKAGE_APP_CORE..".GameView")

local LoginView = class("LoginView",GameView)


function LoginView:initUI()
   LoginView.super.initUI(self)
end


return LoginView