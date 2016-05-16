local GameView = require(cc.PACKAGE_APP_CORE..".GameView")

local LoginView = class("LoginView",GameView)

function LoginView:onRegister()
   self:init("login",cc.viewTypes.PANEL)
end

function LoginView:initUI()
   LoginView.super.initUI(self)
end

function LoginView:dispose()
   LoginView.super.dispose(self)
end

return LoginView