


ActionSegment = class("ActionSegment")


function ActionSegment:add(actionSprite)
    if not self._actionSprites then self._actionSprites = {} end
    table.insert(self._actionSprites,actionSprite)
end



--一段动画效果播放完后回调该方法，使流程进入下一个环结
function ActionSegment:setOnActionEndCallback(onActionEndCallback)
    self._onActionEndCallback = onActionEndCallback
end

function ActionSegment:stop()
     self.isStop = true
     for i,v in ipairs(self._actionSprites) do
         v:stop()
     end
end

function ActionSegment:isStop()
    return self.isStop or false
end

--播放动画
function ActionSegment:run()
    
    local function runAction(actionSprites)
        if not actionSprites then return 0 end
        
        local max_duration_consume = 0
        for i=1,#actionSprites do
            local actionSprite = actionSprites[i]
            actionSprite:run()
            local duration_consume = actionSprite:getDurationConsume() + actionSprite:getDelay()
         
            if max_duration_consume < duration_consume then
                max_duration_consume = duration_consume
            end
        end
        
        return max_duration_consume
    end
    
    local progress_time = runAction(self._actionSprites)

   
    
    --动画播放完成后的回调
    if self._onActionEndCallback then
        PerformWithDelay(nil,progress_time, function() 
            if self._onActionEndCallback then
               self._onActionEndCallback() 
            end
        end)
    end

    return progress_time
end

return ActionSegment