local GameView = require(cc.PACKAGE_APP_CORE..".GameView")

local LoginView = class("LoginView",GameView)

function LoginView:onRegister()
   self:init("login",cc.viewTypes.PANEL)
end

function LoginView:initUI()
   LoginView.super.initUI(self)
   
   local tip = self.ui:getChildByName("tip")
   tip:setPositionX(display.cx)
   tip:setString("这个luagio登录界面")

   local btn_login = self.ui:getChildByName("btn_login")
   
   btn_login:align(display.CENTER,display.cx,display.cy-230)
   
end

function LoginView:dispose()
   LoginView.super.dispose(self)
end

return LoginView