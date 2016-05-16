local ActionSpriteBuilder = class("ActionSpriteBuilder")



--根据特效ID，创建用于播放特效的sprite及action
--支持序列帧及粒子特效
function ActionSpriteBuilder.build(action_id)
    --动画配置
    local config = ConfigManager.getEffectTable(action)

    local action = nil
    local sprite = nil
    
    local frame_count = config.frame_count
    if frame_count > 0 then
        local duration = config.duration
        
        local frame_time = duration/frame_count
       
        sprite,action = createSpriteAndAction(action_id,frame_count,frame_time)
        --缩放
        sprite:setScale(config.scale)
        sprite:setAnchorPoint(ccp(0.5,0.5))

        local actionSprite = ActionSprite:New()
        actionSprite:InitWithAction(sprite,action,config)

        return actionSprite
    else 
        error("Effect: "..action_id.." is not frame animation or particle")
    end
end



--根据动画描述数据，及指定sprite，创建ActionSprite
--支持原生动画
function ActionSpriteBuilder.build(sprite,aciton_key)
    local action_table = action_table or ActionTableManager.getActionTable(aciton_key)

    local config = action_table.config
    config.speed = (action_table.config.speed or 1)

    --根据播放速度，计算动画所占用的流程时间，播放时长，及延迟时长
    config.duration = config.duration / config.speed
    config.duration_consume = config.duration_consume / config.speed
    config.delay = config.delay / config.speed

    local action = ActionSpriteBuilder.parserActionData(config,action_table.action_data)
    local config = action_table.config
    
    local actionSprite = ActionSprite:New()
    
    actionSprite:InitWithAction(sprite,action,config)

    return actionSprite
end

--移除清理animation
function ActionSpriteBuilder:removeAndPurgeAnimation(action_name)
   local animationCache = CCAnimationCache:sharedAnimationCache()
   local animation = animationCache:animationByName(action_name)
   if animation then
      animationCache:removeAnimationByName(action_name)
   end
end

 -- --创建特效依附的sprite和相应的action
function ActionSpriteBuilder.createSpriteAndAction(action_id,frame_count,frame_time)
    local animation = ActionSpriteBuilder.createAndCacheAnimation(action_id,frame_count)
    animation:setDelayPerUnit(frame_time)
    local action = Animate:create(animation)   
    local sprite = display.newSprite()
    return sprite,action
end

--创建并缓存Animation
function ActionSpriteBuilder:createAndCacheAnimation(action_id,frame_count)
    local action_path = ConfigManager.getEffectPath()
    local action_name = ConfigManager.getEffectFileName()
    local animationCache = CCAnimationCache:sharedAnimationCache()
    local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
    local animation = animationCache:animationByName(action_name)
    if not animation then
        if io.exists(action_path..action_name..".plist") then--使用plist
                       
            cache:addSpriteFramesWithFile(action_path..action_name..".plist")
            local animFrames = CCArray:createWithCapacity(frame_count)
            for i=1,frame_count do 
                local framePath = string.format(action_name.."/%02d.png", i)
                local frame = cache:spriteFrameByName(framePath)
                if frame then
                   animFrames:addObject(frame)
                end
            end
            animation = CCAnimation:createWithSpriteFrames(animFrames, 0.04)
        end
        animationCache:addAnimation(animation,action_name)
    end

    return animation,action_name
end




--static CCOrbitCamera * create(float t, float radius, float deltaRadius, float angleZ, float deltaAngleZ, float angleX, float deltaAngleX);



function ActionSpriteBuilder.parserActionData(config,action_data)
    if not action_data then return nil end
    if action_data.CCRepeatForever then--顺序动画
       
        local t = action_data.CCRepeatForever
        return CCRepeatForever:create(ActionSpriteBuilder.parserActionData(config,t))

    elseif action_data.CCSequence then--顺序动画
        local arr = CCArray:create()
        for k,v in pairs(action_data.CCSequence) do
            local t = ActionSpriteBuilder.parserActionData(config,v)
            if t then arr:addObject(t) end
        end
        return CCSequence:create(arr)
        
    elseif action_data.CCSpawn then--并行动画
        local arr = CCArray:create()
        for k,v in pairs(action_data.CCSpawn) do
            local t = ActionSpriteBuilder.parserActionData(config,v)
            if t then arr:addObject(t) end
        end
        return CCSpawn:create(arr)
    elseif action_data.CCCallFunc then--回调
        local t = action_data.CCCallFunc
        return CCCallFunc:create(t)
        
    elseif action_data.CCFadeOut then--淡出
        return CCFadeOut:create(action_data.CCFadeOut/config.speed)
        
    elseif action_data.CCFadeIn then--淡入
        return CCFadeIn:create(action_data.CCFadeIn/config.speed)

    elseif action_data.CCFadeTo then--改变透明度
        local t = action_data.CCFadeTo
        return CCFadeTo:create(t.time/config.speed,t.fade)

    elseif action_data.CCMoveBy then--位移
        local t = action_data.CCMoveBy
        return CCMoveBy:create(t.time/config.speed,ccp(t.x,t.y))

    elseif action_data.CCMoveTo then--位移
        local t = action_data.CCMoveTo
        return CCMoveTo:create(t.time/config.speed,ccp(t.x,t.y))
    elseif action_data.CCJumpTo then -- jump
        local t = action_data.CCJumpTo
        return CCJumpTo:create(t.time/config.speed,ccp(t.x,t.y),t.height,t.count)
    elseif action_data.CCJumpBy then 
        local t = action_data.CCJumpBy
        return CCJumpBy:create(t.time/config.speed,ccp(t.x,t.y),t.height,t.count)
    elseif action_data.CCScaleTo then--缩放
        local t = action_data.CCScaleTo
        return CCScaleTo:create(t.time/config.speed,t.scale * config.scale)
        
    elseif action_data.CCScaleBy then--缩放
        local t = action_data.CCScaleBy
        if t.scaleby then
           return CCScaleBy:create(t.time/config.speed,t.scaleby * config.scale)
        else
           return CCScaleBy:create(t.time/config.speed,t.x * config.scale,t.y*config.scale)
        end
        
    elseif action_data.CCDelayTime then--延迟
        return CCDelayTime:create(action_data.CCDelayTime/config.speed)
        
    elseif action_data.CCRotateTo then--旋转到
        local t = action_data.CCRotateTo
        return CCRotateTo:create(t.time/config.speed,t.rotate)
        
    elseif action_data.CCRotateBy then--旋转by
        local t = action_data.CCRotateBy
        return CCRotateBy:create(t.time/config.speed,t.rotate)

    elseif action_data.CCOrbitCamera then--改变透明度
        local t = action_data.CCOrbitCamera
        local radius = t.radius or 1
        local deltaRadius = t.deltaRadius or 0
        local angleZ = t.angleZ or 0
        local deltaAngleZ = t.deltaAngleZ or 0
        local angleX = t.angleX or 0
        local deltaAngleX = t.deltaAngleX or 0
        return CCOrbitCamera:create(t.time/config.speed,radius,deltaRadius,angleZ,deltaAngleZ,angleX,deltaAngleX)

    elseif action_data.CCOrbitCamera then--3D旋转
        local t = action_data.CCOrbitCamera
        return CCOrbitCamera:create(t.time/config.speed,t.radius,t.deltaRadius,t.angleZ,t.deltaAngleZ,t.angleX,t.deltaAngleX)
    elseif action_data.CCProgressFromTo then--进度条动画
        local t = action_data.CCProgressFromTo
        return CCProgressFromTo:create(t.time/config.speed,t.from,t.to)
    
    elseif action_data.CCEaseExponentialIn then -- 加速 1.指数缓冲
       local t = action_data.CCEaseExponentialIn
       return CCEaseExponentialIn:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCEaseExponentialInOut then -- 加速减速
       local t = action_data.CCEaseExponentialInOut
       return CCEaseExponentialInOut:create(ActionSpriteBuilder.parserActionData(config,t))  
    elseif action_data.CCEaseExponentialOut  then -- 减速
       local t = action_data.CCEaseExponentialOut 
       return CCEaseExponentialOut:create(ActionSpriteBuilder.parserActionData(config,t))

    elseif action_data.CCEaseSineIn then -- 加速 2.赛因缓冲
       local t = action_data.CCEaseSineIn
       return CCEaseSineIn:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCEaseSineInOut then -- 加速减速
       local t = action_data.CCEaseSineInOut
       return CCEaseSineInOut:create(ActionSpriteBuilder.parserActionData(config,t))  
    elseif action_data.CCEaseSineOut  then -- 减速
       local t = action_data.CCEaseSineOut 
       return CCEaseSineOut:create(ActionSpriteBuilder.parserActionData(config,t))

    elseif action_data.CCEaseElasticIn then -- 加速 2.弹性缓冲
       local t = action_data.CCEaseElasticIn
       return CCEaseElasticIn:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCEaseElasticInOut then -- 加速减速
       local t = action_data.CCEaseElasticInOut
       return CCEaseElasticInOut:create(ActionSpriteBuilder.parserActionData(config,t))  
    elseif action_data.CCEaseElasticOut  then -- 减速
       local t = action_data.CCEaseElasticOut 
       return CCEaseElasticOut:create(ActionSpriteBuilder.parserActionData(config,t))

    elseif action_data.CCEaseBounceIn then -- 加速 2.弹性缓冲
       local t = action_data.CCEaseBounceIn
       return CCEaseBounceIn:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCEaseBounceInOut then -- 加速减速
       local t = action_data.CCEaseBounceInOut
       return CCEaseBounceInOut:create(ActionSpriteBuilder.parserActionData(config,t))  
    elseif action_data.CCEaseBounceOut  then -- 减速
       local t = action_data.CCEaseBounceOut 
       return CCEaseBounceOut:create(ActionSpriteBuilder.parserActionData(config,t))

    elseif action_data.CCEaseBounceIn then -- 加速 2.跳跃缓冲
       local t = action_data.CCEaseBounceIn
       return CCEaseBounceIn:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCEaseBounceInOut then -- 加速减速
       local t = action_data.CCEaseBounceInOut
       return CCEaseBounceInOut:create(ActionSpriteBuilder.parserActionData(config,t))  
    elseif action_data.CCEaseBounceOut  then -- 减速
       local t = action_data.CCEaseBounceOut 
       return CCEaseBounceOut:create(ActionSpriteBuilder.parserActionData(config,t))

    elseif action_data.CCEaseBackIn then -- 加速 2.跳跃缓冲
       local t = action_data.CCEaseBackIn
       return CCEaseBackIn:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCEaseBackInOut then -- 加速减速
       local t = action_data.CCEaseBackInOut
       return CCEaseBackInOut:create(ActionSpriteBuilder.parserActionData(config,t))  
    elseif action_data.CCEaseBackOut  then -- 减速
       local t = action_data.CCEaseBackOut 
       return CCEaseBackOut:create(ActionSpriteBuilder.parserActionData(config,t))
    elseif action_data.CCBlink then -- 闪
       local t = action_data.CCBlink
       return CCBlink:create(t.time, t.count)  
    end
end





