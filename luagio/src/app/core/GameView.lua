local CCSPanel = import(".CCSPanel")
local GameView = class("GameView",View)

function GameView:ctor()
   super.View.ctor(self)
end

function GameView:initUI(styleName,viewType)
   self.ui = CCSPanel.new(styleName)
   self.viewType = viewType
end

function GameView:show()
   LayersManager:getInstance():addView(self)
   self:onShow()
end

function GameView:close()
   LayersManager:getInstance():removeView(self)
   self:onClose()
end


function GameView:onShow()

end

function GameView:onClose()

end

function GameView:getUI()
   return self.ui
end

