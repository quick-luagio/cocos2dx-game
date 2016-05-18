--动画播放细节及时序信息


require("core.ActionSpriteBuilder")

ActionSprite = {
_sprite,
_action_id,
_action,
_onFinishedCallback,
_onStartCallback,
_delay,
_duration,
_duration_consume,
_type,
_speed,
_offset_x,
_offset_y,
_sound,
_scale,
_config,
_onCompleteCallback = nil,
_allowFlip = false,
_isStop = false,
}


local ActionSprite = Class("ActionSprite")


function ActionSprite:InitWithAction(sprite,action,config)
    self._sprite = sprite
    self._action = action
    self._config = config
end





--获取动画配置
function ActionSprite:getConfig()
    return self._config
end


function ActionSprite:setOnCompleteCallback(onCompleteCallback)
    self._onCompleteCallback = onCompleteCallback
end

function ActionSprite:setOnFinishedCallback(onFinishedCallback)
    self._onFinishedCallback = onFinishedCallback
end

function ActionSprite:setOnStartCallback(onStartCallback)
    self._onStartCallback = onStartCallback
end


function ActionSprite:getOffset()
    return self._offset_x,self._offset_y
end


--动画作用的sprite
function ActionSprite:getSprite() 
    return self._sprite
end

--cocos2d中的action
function ActionSprite:getAction() 
    return self._action
end

--动画播放完之后的回调，主要用于sprite销毁及资源回收
function ActionSprite.getOnFinishedCallback()
    return self._onFinishedCallback
end


--【从动画配置中读取】动画播放延迟
function ActionSprite:getDelay()
    return self._delay
end

--增加动画延迟
function ActionSprite:addDelay(delay)
   self._delay = self._delay + delay
end


--【从动画配置中读取】动画持续时间
function ActionSprite:getDuration()
    return self._duration
end

--【从动画配置中读取】此动画在战斗流程中实际占用的时间
function ActionSprite:getDurationConsume()
    return self._duration_consume
end

--是否循环播放
function ActionSprite:setRepeatForever(is_repeat_forever)
    self._is_repeat_forever = is_repeat_forever
end

function ActionSprite:setRepeat(count)
    self._repeat_count = count or 0
end

function ActionSprite:stop()
    self._isStop = true
    if self._sprite then
       self._sprite:stopAllActions()
    end
end

function ActionSprite:isStop()
    return self._isStop or false
end

--运行动画
function ActionSprite:run()
    

    local action = self._action

    if tolua.type(action) ~= "CCCallFunc"  then
        if self._is_repeat_forever then
           action = CCRepeatForever:create(self._action)
        elseif self._repeat_count >0 then
           action = CCRepeatForever:create(self._repeat_count)
        else
           --donothings
        end 
    end


    if self._delay > 0 then
       action = CCSequence:createWithTwoActions(CCDelayTime:create(self._delay),action)
    end
    
    if self._onStartCallback then
        action = CCSequence:createWithTwoActions(CCCallFunc:create(self._onStartCallback),action)
    end
    
    --播放声音
    if self._sound and string.len(self._sound) > 0 then
        local sound = self._sound
        if string.find(sound,",") then--如果有多个声音，随机取一个播放
            sound = Split(sound,",")[math.random(3)]
        end
        action = CCSequence:createWithTwoActions(CCCallFunc:create(function() SoundEffect.playSoundEffect(sound) end),action)
    end
   
    --动画播放完成后的回调
    if self._onFinishedCallback then
        action = CCSequence:createWithTwoActions(action,CCCallFunc:create(function() self._onFinishedCallback() end))
    end
    
    if not self:isStop()  then
        --延迟显示动画
        ActionCallback(self._sprite,action,{
                time = self._duration,
                delay = delay + self._delay,
                onComplete=self._onCompleteCallback,
            })
    end
end


function ActionSprite:play()
    
end

function ActionSprite:onComplete()
   
end



function ActionCallback(target, action, args,delayFunc)
    local delay = tonumber(args.delay)
    if type(delay) ~= "number" then delay = 0 end

    local time = tonumber(args.time)
    if type(time) ~= "number" then time = 0 end 

    local onComplete = args.onComplete
    if type(onComplete) ~= "function" then onComplete = nil end

    if action then
        if delay >0 then
           target:retain()
           action:retain()
           PerformWithDelay(target,delay,function() 
               target:runAction(action)
               target:release()
               action:release()
           end)
        else
            target:runAction(action)
        end
    else
        echoInfo("ActionCallback: action is nil")
    end
    
    if onComplete then
        local onCompleteHandle = PerformWithDelay(target,delay + time, function()
            onCompleteHandle = nil
            onComplete()
        end)
    end
end