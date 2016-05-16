--[[--
游戏模块视图

]]


local CCSPanel = import(".CCSPanel")
local GameView = class("GameView",cc.mvc.View)

function GameView:ctor()
   GameView.super.ctor(self)
   self._isInit = false
   self._isActive = false
end
--初始化
function GameView:init(styleName,viewType)
   self.styleName = styleName
   self.viewType = viewType
   self:injectUI()
   self:initUI()

   self._isInit = true

   printInfo("View:init() styleName:%s ,viewType:%s",self.styleName,self.viewType)
end

--提供子类初始化
function GameView:initUI()

end

--注入UI
function GameView:injectUI()
   self.ui = CCSPanel.new(self.styleName)
end

--显示
function GameView:show()
   ViewsMonitor:getInstance():addView(self)
   self:onShow()
end

--关闭
function GameView:close()
   ViewsMonitor:getInstance():removeView(self)
end

--验证是否已经初始化
function GameView:validateInit()
   if not self._isInit then -- 如果释放了，则重新初始化
      self:init(self.styleName,self.viewType)
   end
end

--更新视图数据
function GameView:update(data)
   self:validateInit()
end

--是否处于活跃显示状态
function GameView:isActive()
   return _isActive
end


--当显示时触发
function GameView:onShow()
   self._isActive = true
   printInfo("%s show",self.__cname)
end


--当关闭时触发
function GameView:onClose()
   printInfo("%s close",self.__cname)
   self._isInit = false
   self._isActive = false
   self:dispose()
end

function GameView:dispose()
   printInfo("%s dipose",self.__cname)
end

function GameView:getUI()
   return self.ui
end

return GameView