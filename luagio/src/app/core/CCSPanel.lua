local CCSPanel = class("CCSPanel")

function CCSPanel:create(path)
   return cc.CSLoader:createNode(ConfigManager.getCSBFile(path))
end

return CCSPanel