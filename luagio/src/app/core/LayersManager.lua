local LayersManager = class("LayersManager")
local layerSets ={}

function LayersManager:ctor()
   self._mainLayer = display.newLayer()
   self._mainLayer:retain()
end

function LayersManager:replaceScene(scene)
   if self._mainLayer then
      self._mainLayer:removeFromParent()
   end
   scene:addChild(self._mainLayer)
end

function LayersManager:clearLayers()
   if self._mainLayer then
      self._mainLayer:removeAllChildren()
   end
end

function LayersManager:clear()
   if  self._mainLayer then
	   self._mainLayer:release()
	   self._mainLayer:removeFromParent()
	   self._mainLayer = nil
   end
end

layerSets["PANEL"]     = {zorder=1,cls="PanelLayer",}
layerSets["INFO"]      = {zorder=1,cls="InfoLayer",}
layerSets["DIALOG"]    = {zorder=2,cls="DialogLayer",}
layerSets["LOADING"]   = {zorder=3,}
layerSets["GUIDE"]     = {zorder=4,}
layerSets["TIP"]       = {zorder=5,}


function LayersManager:addView(view)
   if not view.viewType or view.getUI() then
   	  printInfo(string.format(" %s not find viewType or getUI() is nil",rawget(view,"__cname")))
      return
   end

   local layerSet = layerSets[view.viewType]
   
   if isempty(layerSets.cls) then

      _mainLayer:addChild(view:getUI(),layerSet.zorder)

   else
   	  local uiLayer = _mainLayer:getChildByName(view.viewType)
   	  if not uiLayer then
         local Cls = require(layerSets.cls) 
         uiLayer = Cls.new()
         uiLayer:setName(view.viewType)
         _mainLayer:addChild(uiLayer,layerSet.zorder)
   	  end
      uiLayer:addView(view:getUI())
   end
end

function LayersManager:removeLayer(viewType)
   local uiLayer = self:getLayer(viewType)
   if uiLayer then
      uiLayer:removeFromParent()
   end
end

--可视化某个viewType
function LayersManager:visibleLayer(viewType,visible)
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


function LayersManager:getLayer(viewType)
   local layerSet = layerSets[viewType]
   if layerSets.cls then
      return _mainLayer:getChildByName(viewType)
   end
   return nil
end



---------------------------impl  UILayers----------------------------------------------
