--[[--
视图UserView
可以发送消息 dispose 处理资源释放,dispose只是UI暂时失去,视图本身不会释放,initUI 处理UI初始化
重写父类函数时，切记调用父类函数 如 UserView.super.initUI(self)
]]
local GameView = require(cc.PACKAGE_APP_CORE..".GameView")

local UserView = class("UserView",GameView)

function UserView:onRegister()
   self:init("User",cc.viewTypes.PANEL)
end

function UserView:initUI()
   UserView.super.initUI(self)
end


--当ui移除时候
function UserView:dispose()
   UserView.super.dispose(self)
end

return UserView