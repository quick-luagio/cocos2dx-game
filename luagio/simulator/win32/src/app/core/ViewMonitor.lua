local ViewMonitor = class("ViewMonitor")
local layerSets ={}

function ViewMonitor:getInstance()
   if not self._instance then
      self._instance = ViewMonitor.new()
   end
   return self._instance
end

function ViewMonitor:ctor()
   self._mainLayer = display.newLayer()
   self._mainLayer:retain()
end

function ViewMonitor:replaceScene(scene)
   if self._mainLayer then
      self._mainLayer:removeFromParent()
   end
   scene:addChild(self._mainLayer)
end

function ViewMonitor:clearLayers()
   if self._mainLayer then
      self._mainLayer:removeAllChildren()
   end
end

function ViewMonitor:clear()
   if  self._mainLayer then
	   self._mainLayer:release()
	   self._mainLayer:removeFromParent()
	   self._mainLayer = nil
   end
end


function ViewMonitor:addView(view)
   if not view.viewType or not view:getUI() then
   	  printInfo(string.format(" %s not find viewType:[%s] or getUI() is nil",view.__cname,view.viewType or ""))
      return
   end
   local layerSets = cc.cfm.getLayerSets()
   local layerSet = layerSets[view.viewType]
   
   if isempty(layerSets.cls) then

      self._mainLayer:addChild(view:getUI(),layerSet.zorder)

   else
   	  local uiLayer = _mainLayer:getChildByName(view.viewType)
   	  if not uiLayer then
         local Cls = require(layerSets.cls) 
         uiLayer = Cls.new()
         uiLayer:setName(view.viewType)
         _mainLayer:addChild(uiLayer,layerSet.zorder)
   	  end
      uiLayer:addView(view:getUI())
      view:onShow()
   end
end

function ViewMonitor:removeLayer(viewType)
   local uiLayer = self:getLayer(viewType)
   if uiLayer then
      uiLayer:remove()
   end
end

--可视化某个viewType
function ViewMonitor:visibleLayer(viewType,visible)
   local uiLayer = self:getLayer(viewType)
   if uiLayer then
      uiLayer:setVisible(visible)
      if visible then
         uiLayer:resumeSchedulerAndActions()
      else
         uiLayer:pauseSchedulerAndActions()
      end
   end
end


function ViewMonitor:getLayer(viewType)
   local layerSets = cc.cfm.getLayerSets()

   local layerSet = layerSets[viewType]
   if layerSets.cls then
      return _mainLayer:getChildByName(viewType)
   end
   return nil
end

return ViewMonitor

---------------------------impl  UILayers----------------------------------------------
