

local ConfigManager = {}

local _action_configs = nil

local _effect_configs = nil

local _module_configs = nil

local _layer_sets = nil

local _static_configs = nil

function ConfigManager.loadActionConfig()
    if _action_configs then return end
    _action_configs = require(cc.PACKAGE_APP_CONFIG..".Actions")
end

function ConfigManager.loadEffectConfig()
    if _effect_configs then return end
    _effect_configs = require(cc.PACKAGE_APP_CONFIG..".Effects")
end

function ConfigManager.loadModuleConfig()
    if _module_configs then return end
    _module_configs = require(cc.PACKAGE_APP_CONFIG..".Modules")
end

function ConfigManager.loadLayerSets()
    if _layer_sets then return end
    _layer_sets = require(cc.PACKAGE_APP_CONFIG..".LayerSets")
end

function ConfigManager.loadStaticConfig()
    if _static_configs then return end
    _layer_sets = require(cc.PACKAGE_APP_CONFIG..".Statics")
end


--获取action配置
function ConfigManager.getActionTable(action_key)
    if not _action_configs  then
       ConfigManager.loadActionConfig()
    end
    return _action_configs[action_key]
end

--获取静态配置
function ConfigManager.getStaticConfigs()
    if not _static_configs  then
       ConfigManager.loadStaticConfig()
    end
    return _static_configs
end


--获取effect配置
function ConfigManager.getEffectTable(action_id)
    if not _effect_configs  then
       ConfigManager.loadEffectConfig()
    end
    return _effect_configs[action_key]
end


--获取模块配置
function ConfigManager.getModuleConfig()
   if not _module_configs  then
       ConfigManager.loadModuleConfig()
    end
    return _module_configs
end

--获取effect所在文件路径
function ConfigManager.getEffectPath()
   return cc.paths.Effect_Path
end

--获取effect 文件名
function ConfigManager.getEffectFileName(action_id)
   return string.format("%s_%s","effect",action_id)
end

--获取csb文件
function ConfigManager.getCSBFile(path)
   return string.format("%s.csb",path)
end

--获取层次配置
function ConfigManager.getLayerSets()
    if not _layer_sets  then
       ConfigManager.loadLayerSets()
    end
    return _layer_sets
end


return ConfigManager



