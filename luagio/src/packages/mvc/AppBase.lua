
local AppBase = class("AppBase")

function AppBase:ctor(configs)
    
    self._configs = configs or  {
                                    defaultScene = "MainScene",
                                    scene_package = "app.scenes"
                                } 
    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

    
    self:onRegister()
end

function AppBase:run(initSceneName)
    initSceneName = initSceneName or self._configs.defaultScene
    self:enterScene(initSceneName)
end

function AppBase:enterScene(sceneName, transition, time, more)
    local scene = self:createScene(sceneName)
    display.runScene(scene, transition, time, more)
    return scene
end


function AppBase:createScene(sceneName)
   return require(self._configs.scene_package.."."..sceneName).new()
end



function AppBase:onRegister()

end

return AppBase
