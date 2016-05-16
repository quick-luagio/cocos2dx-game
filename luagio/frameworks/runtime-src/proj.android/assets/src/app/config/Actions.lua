local _action_configs ={}

-- 场景视角移动
_action_configs["UI_Fight_Scene_View_Move"] = {
    action_data = {
       CCEaseSineOut={CCMoveBy={time=1,x=-400,y=0}}
    },
    config={
        delay = 0,
        duration = 1.1,
        duration_consume = 1.1,
        speed = 1,
        scale = 1,
        offset_x = 0,
        offset_y = 0,
    }
}



return _action_configs