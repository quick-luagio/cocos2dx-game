
local async = require("core.async")

local animationCache = CCAnimationCache:sharedAnimationCache()
local frameCache = CCSpriteFrameCache:sharedSpriteFrameCache()
local textureCache = CCTextureCache:sharedTextureCache()

AsynLoader = class("AsynLoader")

AsynLoader.single = 0
AsynLoader.multi = 1

function AsynLoader:ctor()
   self:reset()
end

function AsynLoader:addUIEffect(effect_id,handler,imageType)
   local imageUrl = string.format("drawable/ui_effect/ui_effect_%s%s",effect_id,imageType or ".png")
   local plistUrl = string.format("drawable/ui_effect/ui_effect_%s.plist",effect_id)
   self:addImage(imageUrl,plistUrl,handler)
end


function AsynLoader:addFightEffect(effect_id,handler,imageType)
   local imageUrl = string.format("drawable/fight_effect/fight_effect_%s%s",effect_id,imageType or ".png")
   local plistUrl = string.format("drawable/fight_effect/fight_effect_%s.plist",effect_id)
   self:addImage(imageUrl,plistUrl,handler)
end

--设置类型
function AsynLoader:setLoaderType(type)
   self._loaderType = type
end


function AsynLoader:addImage(imageUrl,plistUrl,handler)
   local loaderItem = {imageUrl=imageUrl,plistUrl=plistUrl,handler=handler}
   table.insert(self._list,loaderItem)   
   self:validateStart()
end

function AsynLoader:setProgressHandler(progressHandler)
   self.progressHandler = progressHandler
end

function AsynLoader:calProgress()
   local loadCount = 0 
   for i,item in ipairs(self._list) do
       if item.isLoaded then
          loadCount = loadCount + 1
       end
   end
   self.progress = math.round(100*loadCount/#self._list)
   if self.progressHandler then
      self.progressHandler(self.progress)
   end
end

function AsynLoader:getProgress()
   return self.progress
end

--验证开始
function AsynLoader:validateStart()
    if self._loaderType == AsynLoader.single then
       if not self:isLoading() then
            self:start()
       end
   end
end

function AsynLoader:addBone(dataUrl,handler)
   local loaderItem = {dataUrl=dataUrl,handler=handler}
   table.insert(self._list,loaderItem) 
   self:validateStart()  
end

function AsynLoader:setFinishHandler(finishHandler)
   self.finishHandler = finishHandler
end

function AsynLoader:isLoading()
   return self._isLoading 
end



function AsynLoader:start()
  self._allow = true

    local processor = function(item, next)
      self:calProgress()
      if item.isLoaded then -- 已经加载 
         if self._allow then
            next()
         end
         return
      end
      if item.imageUrl then -- 图片
         self._isLoading = true
         textureCache:addImageAsync(item.imageUrl,function(texture)
           item.isLoaded = true
           if item.plistUrl then
              local texture = textureCache:textureForKey(item.imageUrl)
              frameCache:addSpriteFramesWithFile(item.plistUrl,texture)
              if item.handler then
                 item.handler(item)
              end
           end
           self._isLoading = false
           if self._allow then
              next()
           end
         end)
      elseif item.dataUrl then --骨骼
         self._isLoading = true
         CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfoAsync(item.dataUrl,function()

            if item.handler then
                item.handler()
            end
            self.isLoading = false

            if self._allow then
              next()
            end
         end)
      end
    end

    async.eachSeries(self._list, processor, function(err)
      assert((err == nil))
      end,function() 
      self:calProgress()
      if self.finishHandler then -- 完成后
         self.finishHandler()
      end
      self:reset()
    end)
end

function AsynLoader:stop()
   self._allow = false
end

function AsynLoader:disposeEvent()
  for i,v in ipairs(self._list) do
      v.handler = nil 
  end
end


function AsynLoader:reset()
   self._list ={}
   self._allow = false
   self._loaderType = AsynLoader.single
   self._isLoading  = false
   self.progress = 0
end


function AsynLoader:getInstance()
   if not self._instance then
      self._instance = AsynLoader.new()
   end
   return self._instance 
end


return AsynLoader